import argparse
import datetime
import os
import shutil
import subprocess


###
#   Path variables
#
#   Note: Change these to your system settings!
#
pathRoot = "C:\\quark"
pathRuntime = os.path.join(pathRoot, "runtime")
pathSource = os.path.join(pathRoot, "source")
pathInfobase = os.path.join(pathRoot, "infobase")
pathUtils = os.path.join(pathRoot, "utils")
pathMakeInstall = os.path.join(pathUtils, "make_install")
pathDCC = "C:\\Program Files\\Borland\\Delphi7\\Bin\\DCC32.EXE"
pathUPX = os.path.join(pathMakeInstall, "upx", "upx.exe")
pathMT = os.path.expandvars(os.path.join("%ProgramFiles(x86)%", "Windows Kits", "10", "bin", "10.0.26100.0", "x86", "mt.exe")) #FIXME: Hardcoded SDK version!
pathAddMaker = os.path.join(pathMakeInstall, "addmaker", "addmaker.exe")
pathSFXStub = os.path.join(pathMakeInstall, "SFX", "SFX.exe")
pathNSIS = "C:\\Program Files\\NSIS\\makensis.exe"
pathNSISScript = os.path.join(pathUtils, "nsis-dist-tools")

pathTemp = "C:\\QuArK_installer_files" #New directory where the program files will be gathered.
#Note: args.OUTPUTDIR will contain the output files (installer, archives, etc.)
pathCompileTemp = "C:\\quark tmp"

del pathRoot #No longer needed

#Retrieve current date once, for consistency during script execution.
now = datetime.datetime.now()


###
#   Handle command line arguments
#
args = argparse.ArgumentParser()
args.add_argument('OUTPUTDIR', metavar='dir', help='Directory to gather output files in (must be fully qualified ie "c:\\quark\\install").')
args.add_argument('VERSION', metavar='version', help='Verify version of quark to build. Example: "6.6 Beta 8".') #FIXME: We need a version with spaces... PROBABLY.
args.add_argument('--SNAPSHOT', required=False, help='Create a snapshot archive.')
args.add_argument('--NIGHTLY', required=False, action='store_true', help='Create a nightly release.')
args.add_argument('--DEBUG', required=False, action='store_true', help='Make debug exe.')
args.add_argument('--NOCOMPILE', dest='COMPILE', required=False, action='store_false', help='Doesn\'t compile a new .exe.')
args.add_argument('--NOCOMPRESSEXE', dest='COMPRESSEXE', required=False, action='store_false', help='Doesn\'t compress .exe with "upx".')
args.add_argument('--NOMANIFEST', dest='MANIFEST', required=False, action='store_false', help='Doesn\'t embed manifest in .exe.')
args.add_argument('--NORUNTIME', dest='RUNTIME', required=False, action='store_false', help='Doesn\'t copy runtime files.')
args.add_argument('--NOD3D', dest='ALLOWD3D', required=False, action='store_false', help='Doesn\'t add QuArK D3D files.')
args.add_argument('--NOHELP', dest='HELP', required=False, action='store_false', help='Doesn\'t create help files.')
args.add_argument('--NOHELPZIP', dest='HELPZIP', required=False, action='store_false', help='Doesn\'t create help files ZIP archive.')
args.add_argument('--ALLOWRUNTIMEMODIFICATION', dest='ALLOWRUNTIMEMODIFICATION', required=False, action='store_true', help='Pause after gathering runtime, before making installer, to allow for manual modifications.')
args.add_argument('--NOSFX', dest='SFX', required=False, action='store_false', help='Doesn\'t create SFX extractor.')
args.add_argument('--NONSIS', dest='NSIS', required=False, action='store_false', help='Doesn\'t create NSIS installer.')
args = args.parse_args()


###
#   Check for incorrect or incompatible values
#
if len(args.VERSION) == 0:
	raise ValueError("Must set a version to verify!")
parts = args.VERSION.split(" ")
if len(parts) == 2:
	parts, version_release = parts
	version_patch = None
elif len(parts) == 3:
	parts, version_release, version_patch = parts
else:
	raise ValueError("Invalid format for version!")
parts = parts.split(".")
if len(parts) != 2:
	raise ValueError("Invalid format for version!")
version_major, version_minor = parts
version_revision = "0"
del parts #Release for GC

if args.SNAPSHOT:
	try:
		snapshot_date = datetime.datetime.strptime(args.SNAPSHOT, '%Y%m%d')
	except (ValueError, ):
		raise ValueError("SNAPSHOT is set to an invalid date!")
	if snapshot_date.date() != now.date():
		print("WARNING: SNAPSHOT date does not match today!")

if args.NIGHTLY:
	if args.SNAPSHOT:
		raise ValueError("Cannot make a nightly snapshot!")
	nightly_date = now.date()

if args.DEBUG and not args.COMPILE:
	raise ValueError("Cannot set DEBUG if NOCOMPILE is set!")

if not args.RUNTIME:
	if args.SFX:
		raise ValueError("Cannot create SFX extractor if NORUNTIME is set!")
	if args.NSIS:
		raise ValueError("Cannot create NSIS installer if NORUNTIME is set!")


###
#   Check dependencies
#
def check_dependencies():
	if args.COMPILE:
		try:
			proc = subprocess.run((pathDCC, ), capture_output=True)
		except (FileNotFoundError, ):
			raise RuntimeError("Delphi compiler not found!")
		if proc.returncode != 0:
			if len(proc.stdout) != 0:
				print(proc.stdout)
			if len(proc.stderr) != 0:
				print(proc.stderr)
			raise RuntimeError("Delphi compiler appears to be broken!")
		header = proc.stdout.splitlines()[0].decode("UTF-8")
		index = header.find("Copyright")
		if index != -1:
			header = header[:index].rstrip()
		del index
		product_name, version_tag, version = header.rsplit(" ", 2)
		if version_tag not in set({"Version", "version"}):
			raise RuntimeError("Parse failure!")
		delphi_version = version.split(".")
		if int(delphi_version[0]) > 13:
			try:
				proc = subprocess.run((pathDCC, "--version"), capture_output=True)
			except (FileNotFoundError, ):
				raise RuntimeError("Delphi compiler not found!")
			if proc.returncode != 0:
				if len(proc.stdout) != 0:
					print(proc.stdout)
				if len(proc.stderr) != 0:
					print(proc.stderr)
				raise RuntimeError("Delphi compiler appears to be broken!")
			header = proc.stdout.splitlines()[0].decode("UTF-8")
			product_name, version = header.rsplit(" ", 1)
			delphi_version = version.split(".")

		#QuArK needs dynamic array support (Delphi 4+)
		if int(delphi_version[0]) < 12:
			raise RuntimeError("Delphi too old; version 4 or higher required!")

	if args.COMPRESSEXE:
		try:
			proc = subprocess.run((pathUPX, "-V"), capture_output=True)
		except (FileNotFoundError, ):
			raise RuntimeError("UPX compressor not found!")
		if proc.returncode != 0:
			if len(proc.stdout) != 0:
				print(proc.stdout)
			if len(proc.stderr) != 0:
				print(proc.stderr)
			raise RuntimeError("UPX compressor appears to be broken!")
		#FIXME: Check for version...?

	if args.MANIFEST:
		try:
			proc = subprocess.run((pathMT, "/?"), capture_output=True)
		except (FileNotFoundError, ):
			raise RuntimeError("Manifest tool not found!")
		if proc.returncode != 0:
			if len(proc.stdout) != 0:
				print(proc.stdout)
			if len(proc.stderr) != 0:
				print(proc.stderr)
			raise RuntimeError("Manifest tool appears to be broken!")

	if args.HELP:
		try:
			proc = subprocess.run(("python", "-V"), capture_output=True)
		except (FileNotFoundError, ):
			raise RuntimeError("Python not found!")
		if proc.returncode != 0:
			if len(proc.stdout) != 0:
				print(proc.stdout)
			if len(proc.stderr) != 0:
				print(proc.stderr)
			raise RuntimeError("Python appears to be broken!")
		index = proc.stdout.find(b"\r\n")
		if index != -1:
			python_version = proc.stdout[:index]
		else:
			python_version = proc.stdout
		python_version = python_version.decode("UTF-8")
		if not python_version.startswith("Python "):
			raise RuntimeError("Unexpected Python version!")
		python_version = python_version[len("Python "):].split(".")
		if int(python_version[0]) < 3:
			raise RuntimeError("Python too old; version 3.x or higher required!")
		#Not going to check the exact version; this'll have to do...

	if args.SFX:
		if not os.path.exists(pathAddMaker):
			raise RuntimeError("AddMaker missing!")
		if not os.path.exists(pathSFXStub):
			raise RuntimeError("SFXStub missing!")

	if args.NSIS:
		try:
			proc = subprocess.run((pathNSIS, "/VERSION"), capture_output=True)
		except (FileNotFoundError, ):
			raise RuntimeError("NSIS not found!")
		if proc.returncode != 0:
			if len(proc.stdout) != 0:
				print(proc.stdout)
			if len(proc.stderr) != 0:
				print(proc.stderr)
			raise RuntimeError("NSIS appears to be broken!")
		version = proc.stdout.decode("UTF-8")
		if version.startswith("v"):
			version = version[len("v"):]
		nsis_version = version.split(".")
		if int(nsis_version[0]) < 3:
			raise RuntimeError("NSIS too old; version 3.x or higher required!")

	return


###
#   Create directories
#
def setup_dirs():
	print("Setting up destination directory...")

	if os.path.exists(pathTemp):
		raise FileExistsError("Temporary directory already exists!")
	os.makedirs(pathTemp)

	if os.path.exists(args.OUTPUTDIR):
		if len(os.listdir(args.OUTPUTDIR)) != 0:
			print("WARNING: Existing output directory is non-empty!")
	else:
		os.makedirs(args.OUTPUTDIR)
	return


###
#   Copy runtime files
#
def copy_runtime():
	print("Copying runtime files...")
	excluded = set()
	with open(os.path.join(pathMakeInstall, "exclude.txt"), mode="r") as inFile:
		for line in inFile:
			excluded.add(line.rstrip("\r\n"))
	shutil.copytree(pathRuntime, pathTemp, ignore=shutil.ignore_patterns(*excluded), dirs_exist_ok=True)

	#Remove D3D files, if requested
	if not args.ALLOWD3D:
		print("Removing D3D files...")
		os.remove(os.path.join(pathTemp, "dlls", "d3dxas.dll"))
		os.remove(os.path.join(pathTemp, "dlls", "readme.txt"))

	return


###
#   Create + copy + zip infobase
#
def build_help():
	print("Creating Help files...")

	proc = subprocess.run(("python", "build.py", "--local", os.path.join(pathTemp, "help")), cwd=pathInfobase)
	if proc.returncode != 0:
		#if len(proc.stdout) != 0:
		#	print(proc.stdout)
		#if len(proc.stderr) != 0:
		#	print(proc.stderr)
		raise RuntimeError("Failed to create Help files!")

	if args.HELPZIP:
		print("Zipping Help files...")
		shutil.make_archive(os.path.join(args.OUTPUTDIR, "QuArK_%s-help" % (args.VERSION, )), "zip", os.path.join(pathTemp, "help"))

	return


###
#   Check the compile date set in QConsts.pas
#
def check_compile_date():
	#Delphi doesn't have functionality to put the date of the compile in the executable, so we are doing this manually. Check that the date has actually been set to today!
	compile_date = None
	with open(os.path.join(pathSource, "prog", "QConsts.pas"), mode='r') as inFile:
		for line in inFile:
			parts = line.strip().split("=")
			if len(parts) != 2:
				continue
			if parts[0].rstrip() == "QuArKCompileDate":
				parts = parts[1].split(";")
				if len(parts) != 2:
					raise RuntimeError("QConsts.pas appears to be corrupt?!")
				compile_date = datetime.date(1899, 12, 30) + datetime.timedelta(days=int(parts[0]))
				break
	if compile_date is None:
		raise RuntimeError("QConsts.pas appears to be corrupt?!")
	if compile_date != now.date():
		print("WARNING: Compile date in QConsts.pas does not match today!")
	return


###
#   Build debug or non-debug exe
#
def build_exe():
	print("Compiling new executable...")
	if os.path.exists(os.path.join(args.OUTPUTDIR, "compile_errors.txt")):
		os.remove(os.path.join(args.OUTPUTDIR, "compile_errors.txt"))
	#CLI compiler uses a dcc32.cfg file.
	if os.path.exists(os.path.join(pathSource, "dcc32.cfg")):
		raise RuntimeError("dcc32.cfg file already exists!")
	with open(os.path.join(pathSource, "QuArK.cfg"), mode="r") as inFile:
		with open(os.path.join(pathSource, "dcc32.cfg"), mode="w") as outFile:
			for line in inFile:
				if (line.strip() == "-$D-") and args.DEBUG:
					outFile.write("-$D+\n") #$D- = no debug info
				elif (line.strip() == "-$L+") and not args.DEBUG:
					outFile.write("-$L+\n") #$L- = no local debug symbols
				elif (line.strip() == "-$O-") and not args.DEBUG:
					outFile.write("-$O+\n") #$O+ = optimization
				else:
					outFile.write(line)
	try:
		#Note: Some compilers also find the QuArK.cfg file, and get confused. So let's move it out of the way.
		os.rename(os.path.join(pathSource, "QuArK.cfg"), os.path.join(pathSource, "QuArK.cfg.real"))
		try:
			#B = recompile ALL units, H = show hints, W = show warnings, Q = don't list all the unit file names
			if args.DEBUG:
				proc = subprocess.run((pathDCC, "QuArK.dpr", "-B", "-DDEBUG", "-E%s" % (pathCompileTemp, ), "-N%s" % (pathCompileTemp, ), "-H", "-W", "-Q"), cwd=pathSource, capture_output=True)
			else:
				proc = subprocess.run((pathDCC, "QuArK.dpr", "-B", "-E%s" % (pathCompileTemp, ), "-N%s" % (pathCompileTemp, ), "-H", "-W", "-Q"), cwd=pathSource, capture_output=True)
		finally:
			os.rename(os.path.join(pathSource, "QuArK.cfg.real"), os.path.join(pathSource, "QuArK.cfg"))

		#Save the compile logs.
		with open(os.path.join(args.OUTPUTDIR, "compile.log"), mode='wb') as outFile:
			outFile.write(proc.stdout)
			if len(proc.stderr) != 0:
				outFile.write(proc.stderr)

		#Check if something went wrong.
		if proc.returncode != 0:
			raise RuntimeError("Failed to compile source - check \"compile.log\"!")
		if not os.path.exists(os.path.join(pathCompileTemp, "QuArK.exe")):
			raise RuntimeError("Compiler did not produce expected executable - check \"compile.log\"!")
	finally:
		os.remove(os.path.join(pathSource, "dcc32.cfg"))

	#Move the debugging files.
	if args.NIGHTLY:
		shutil.move(os.path.join(pathCompileTemp, "QuArK.map"), os.path.join(args.OUTPUTDIR, "QuArK_nightly_%s.map" % (nightly_date.strftime('%d%b%Y').lstrip("0"), )))
	else:
		shutil.move(os.path.join(pathCompileTemp, "QuArK.map"), os.path.join(args.OUTPUTDIR, "QuArK_%s.map" % (args.VERSION, )))

	if args.MANIFEST:
		print("Embedding manifest...")
		proc = subprocess.run((pathMT, "-nologo", "-validate_manifest", "-canonicalize", "-check_for_duplicates", "-manifest", os.path.join(pathSource, "QuArK.manifest"), "-outputresource:QuArK.exe"), cwd=pathCompileTemp, capture_output=True)
		if proc.returncode != 0:
			if len(proc.stdout) != 0:
				print(proc.stdout)
			if len(proc.stderr) != 0:
				print(proc.stderr)
			raise RuntimeError("Failed to embed manifest!")

	if args.COMPRESSEXE:
		print("Compressing executable...")
		proc = subprocess.run((pathUPX, "--best", "--ultra-brute", "--no-lzma", "--overlay=strip", "QuArK.exe"), cwd=pathCompileTemp)
		if proc.returncode != 0:
			#if len(proc.stdout) != 0:
			#	print(proc.stdout)
			#if len(proc.stderr) != 0:
			#	print(proc.stderr)
			raise RuntimeError("Failed to compress executable!")

	#Copy executable into output directory.
	shutil.copy2(os.path.join(pathCompileTemp, "QuArK.exe"), args.OUTPUTDIR)

	return


###
#   Create an archive of all the files
#
def make_archive():
	print("Creating file archive...")
	if args.SNAPSHOT:
		with open(os.path.join(pathTemp, "CHANGES.TXT"), mode="w") as outFile:
			outFile.write(" -------------------- HISTORY FOR .PAS files after $(LASTSNAPSHOTDATE) ---------------------------\n")
			#FIXME: Still need to convert?: find $(SOURCEPATH) -name "*.pas" -type f | xargs -t -i@ perl getlog.pl @ $(LASTSNAPSHOTDATE)
			outFile.write(" -------------------- HISTORY FOR .py files after $(LASTSNAPSHOTDATE) ---------------------------\n")
			#FIXME: Still need to convert?: find $(RUNTIMEPATH) -name "*.py" -type f | xargs -t -i@ perl getlog.pl @ $(LASTSNAPSHOTDATE)
			outFile.write(" -------------------- HISTORY FOR .qrk files after $(LASTSNAPSHOTDATE) ---------------------------\n")
			#FIXME: Still need to convert?: find $(RUNTIMEPATH) -name "*.qrk" -type f | xargs -t -i@ perl getlog.pl @ $(LASTSNAPSHOTDATE)

		with open(os.path.join(pathTemp, "README_SNAPSHOT.TXT"), mode="w") as outFile:
			outFile.write("This is a snapshot compile of QuArK from the repository. It represents the current development state of QuArK and probably contains Bugs. Please report them to the QuArK forum at https://quark.sourceforge.io/forums/\n")
			outFile.write("This snapshot was compiled on: %s" % (now.strftime("%d %B %Y").lstrip("0"), ))

		archive_filename = "quarksnapshot_%s" % (snapshot_date.strftime('%Y%m%d'), )
	else:
		archive_filename = "QuArK_%s" % (args.VERSION, )

	#Note: Snapshots used to be in the .ace format.
	shutil.make_archive(os.path.join(args.OUTPUTDIR, archive_filename), "zip", pathTemp)

	return


###
#   SFX
#
def sfx():
	print("Creating SFX archives...")
	if os.path.exists(os.path.join(args.OUTPUTDIR, "QuArK_%s.zip" % (args.VERSION, ))):
		proc = subprocess.run((pathAddMaker, "-caption", "QuArK %s Installer" % (args.VERSION, ), "-message", "This will install QuArK %s. Do you want to continue?" % (args.VERSION, ), "-messagestyle", "2", "-defaultdir", "C:\\QuArK_%s" % (args.VERSION, ), "-output", "QuArK_%s.add" % (args.VERSION, ), "-flags", "12", "-pyflags", "5", "-pyver", "150"), cwd=args.OUTPUTDIR, capture_output=True) #FIXME: Hardcoded Python flags and version!
		if proc.returncode != 0:
			if len(proc.stdout) != 0:
				print(proc.stdout)
			if len(proc.stderr) != 0:
				print(proc.stderr)
			raise RuntimeError("Failed to create SFX archive for QuArK!")
		with open(os.path.join(args.OUTPUTDIR, "QuArK_%s-Setup.exe" % (args.VERSION, )), mode="wb") as outFile:
			with open(pathSFXStub, mode="rb") as inFile:
				outFile.write(inFile.read())
			with open(os.path.join(args.OUTPUTDIR, "QuArK_%s.add" % (args.VERSION, )), mode="rb") as inFile:
				outFile.write(inFile.read())
			with open(os.path.join(args.OUTPUTDIR, "QuArK_%s.zip" % (args.VERSION, )), mode="rb") as inFile:
				outFile.write(inFile.read())
		os.remove(os.path.join(args.OUTPUTDIR, "QuArK_%s.add" % (args.VERSION, )))
	if os.path.exists(os.path.join(args.OUTPUTDIR, "QuArK_%s-help.zip" % (args.VERSION, ))):
		proc = subprocess.run((pathAddMaker, "-caption", "QuArK %s Help Installer" % (args.VERSION, ), "-message", "This will install help files for QuArK %s. Do you want to continue?" % (args.VERSION, ), "-messagestyle", "2", "-defaultdir", "C:\\QuArK_%s\\help" % (args.VERSION, ), "-output", "QuArK_%s-help.add" % (args.VERSION, ), "-flags", "12", "-pyflags", "0", "-pyver", "0"), cwd=args.OUTPUTDIR, capture_output=True)
		if proc.returncode != 0:
			if len(proc.stdout) != 0:
				print(proc.stdout)
			if len(proc.stderr) != 0:
				print(proc.stderr)
			raise RuntimeError("Failed to create SFX archive for QuArK help files!")
		with open(os.path.join(args.OUTPUTDIR, "QuArK_%s-Setup-help.exe" % (args.VERSION, )), mode="wb") as outFile:
			with open(pathSFXStub, mode="rb") as inFile:
				outFile.write(inFile.read())
			with open(os.path.join(args.OUTPUTDIR, "QuArK_%s-help.add" % (args.VERSION, )), mode="rb") as inFile:
				outFile.write(inFile.read())
			with open(os.path.join(args.OUTPUTDIR, "QuArK_%s-help.zip" % (args.VERSION, )), mode="rb") as inFile:
				outFile.write(inFile.read())
		os.remove(os.path.join(args.OUTPUTDIR, "QuArK_%s-help.add" % (args.VERSION, )))
	return


###
#   NSIS
#
def nsis():
	if args.NIGHTLY:
		installer_filename = "quark-win32-%s.%s.%s%s%sNightly%s.exe" % (version_major, version_minor, version_revision, version_release, version_patch, nightly_date.strftime('%d%b%Y').lstrip("0"))
	else:
		installer_filename = "quark-win32-%s.%s.%s%s%s.exe" % (version_major, version_minor, version_revision, version_release, version_patch)
	proc = subprocess.run((pathNSIS, "/NOCONFIG", '/DBUILDDIR=%s' % (pathTemp, ), '/DSPLASHDIR=%s' % (pathNSISScript, ), '/DINSTALLER_EXENAME=%s' % (installer_filename, ), "--", os.path.join(pathNSISScript, "QuArK.nsi")))
	if proc.returncode != 0:
		#if len(proc.stdout) != 0:
		#	print(proc.stdout)
		#if len(proc.stderr) != 0:
		#	print(proc.stderr)
		raise RuntimeError("Failed to create NSIS installer!")
	shutil.move(os.path.join(pathNSISScript, installer_filename), args.OUTPUTDIR)
	return


###
#   Do all the things
#
if __name__ == "__main__":
	check_dependencies()

	#Check that the version-numbers set in various files, match.
	proc = subprocess.run(("python", os.path.join(pathUtils, "CheckVersionNumber.py"), version_major, version_minor, version_revision, version_release, version_patch, pathSource, pathRuntime))
	if proc.returncode != 0:
		#if len(proc.stdout) != 0:
		#	print(proc.stdout)
		#if len(proc.stderr) != 0:
		#	print(proc.stderr)
		raise RuntimeError("Failed to run CheckVersionNumber.py!")

	setup_dirs()
	if args.RUNTIME:
		copy_runtime()

		#Check that the QuArKProtected-flag is set on all official QuArK addon files.
		proc = subprocess.run(("python", os.path.join(pathUtils, "CheckAddonProtected.py"), pathRuntime))
		if proc.returncode != 0:
			#if len(proc.stdout) != 0:
			#	print(proc.stdout)
			#if len(proc.stderr) != 0:
			#	print(proc.stderr)
			raise RuntimeError("Failed to run CheckAddonProtected.py!")

		#Check for uniqueness in qdictionnary entries.
		proc = subprocess.run(("python", os.path.join(pathUtils, "CheckDictionaryUniqueness.py"), pathRuntime))
		if proc.returncode != 0:
			#if len(proc.stdout) != 0:
			#	print(proc.stdout)
			#if len(proc.stderr) != 0:
			#	print(proc.stderr)
			raise RuntimeError("Failed to run CheckDictionaryUniqueness.py!")

	if args.COMPILE:
		check_compile_date()
		build_exe()
		#Move executable into place.
		if args.RUNTIME:
			shutil.move(os.path.join(args.OUTPUTDIR, "QuArK.exe"), pathTemp)
	else:
		#Use existing executable, if one is required
		if args.RUNTIME:
			shutil.copy2(os.path.join(pathRuntime, "QuArK.exe"), pathTemp)

	if args.HELP:
		build_help()

	if args.RUNTIME:
		#Check that there are no unexpected files present, or expected files missing in the release.
		proc = subprocess.run(("python", os.path.join(pathUtils, "CheckReleaseFiles.py"), pathTemp))
		if proc.returncode != 0:
			#if len(proc.stdout) != 0:
			#	print(proc.stdout)
			#if len(proc.stderr) != 0:
			#	print(proc.stderr)
			raise RuntimeError("Failed to run CheckReleaseFiles.py!")

		if not args.DEBUG:
			if os.path.exists(os.path.join(pathTemp, "FastMM_FullDebugMode.dll")):
				print("WARNING: DEBUG not set, but FastMM_FullDebugMode.dll present!")

		if args.ALLOWRUNTIMEMODIFICATION:
			print("***PAUSE*** Make manual modifications to the runtime files now!")
			input()

	make_archive()
	if not args.SNAPSHOT:
		if args.SFX:
			sfx()
		if args.NSIS:
			nsis()

	print("All done!")
