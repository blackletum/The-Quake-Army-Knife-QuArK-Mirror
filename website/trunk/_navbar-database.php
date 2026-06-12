<?php
require_once('_functions.php');
require_once('_navbar_functions.php');
require_once('_main_paths.php');

global $mainroot;
global $infobaseroot;
global $svnroot;

global $webmasteremail;

global $navbar;
$navbar = array(
#              Indent, Title                  ,Icon          ,URL
   new cNavbarLine( 0,'worldspawn'            ,'worldspawn'  ,$mainroot.'index.php'                                 )

  ,new cNavbarLine( 1,  'News'                ,'news'        ,$mainroot.'news.php'                                  )
  ,new cNavbarLine( 2,    'Archive'           ,NULL          ,$mainroot.'archivednews.php'                          )
  ,new cNavbarLine( 2,    'Submit news'       ,NULL          ,substr(DisplayEncodedEmail($webmasteremail), 1, -1)   ) #FIXME: Ugly hack to remove double quotes.

  ,new cNavbarLine( 1,  'QuArK'               ,'quark'       ,NULL                                                  )
  ,new cNavbarLine( 2,    'Features'          ,NULL          ,$mainroot.'features.php'                              )
  ,new cNavbarLine( 2,    'Screenshots'       ,NULL          ,$mainroot.'features.php#screenshots'                  )
  ,new cNavbarLine( 2,    'Awards'            ,NULL          ,$mainroot.'awards.php'                                )
  ,new cNavbarLine( 2,    'Videos'            ,NULL          ,$mainroot.'videos.php?*=1'                            )
  ,new cNavbarLine( 2,    'Games'             ,NULL          ,$mainroot.'games.php?showxp=1'                        )
  ,new cNavbarLine( 2,    'Testimonials'      ,NULL          ,$mainroot.'testimonials.php'                          )
  ,new cNavbarLine( 2,    'Download'          ,'download'    ,NULL                                                  )
  ,new cNavbarLine( 3,      'QuArK'           ,NULL          ,$mainroot.'download.php'                              )
  ,new cNavbarLine( 3,      'QuArK Addons'    ,NULL          ,$mainroot.'download_addons.php'                       )
# ,new cNavbarLine( 3,      'Oldies'          ,NULL          ,$mainroot.'download_oldies.php'                       )
  ,new cNavbarLine( 3,      'Game Tools'      ,NULL          ,$mainroot.'download_tools.php'                        )
  ,new cNavbarLine( 3,      'Game Paks'       ,NULL          ,$mainroot.'download_gamepaks.php'                     )
  ,new cNavbarLine( 3,      'Game Patches'    ,NULL          ,$mainroot.'download_gamepatches.php'                  )
  ,new cNavbarLine( 3,      'Game Other'      ,NULL          ,$mainroot.'download_other.php'                        )
# ,new cNavbarLine( 3,      'Python'          ,NULL          ,$mainroot.'download.php#python'                       )
# ,new cNavbarLine( 3,      'Dependencies'    ,NULL          ,$mainroot.'download.php#dependencies'                 )
  ,new cNavbarLine( 3,      'Online-help'     ,NULL          ,$mainroot.'download.php#help'                         )
# ,new cNavbarLine( 3,      'Build-packs'     ,NULL          ,$mainroot.'download.php#buildpacks'                   )
# ,new cNavbarLine( 3,      'Plug-ins'        ,NULL          ,$mainroot.'download.php#plugins'                      )
# ,new cNavbarLine( 3,      'Misc. Utils.'    ,NULL          ,$mainroot.'download.php#misc'                         )
  ,new cNavbarLine( 3,      'Source Code'     ,NULL          ,$svnroot                                              )
  ,new cNavbarLine( 2,    'Credits'           ,NULL          ,$mainroot.'credits.php'                               )
  ,new cNavbarLine( 2,    'Donate'            ,NULL          ,$mainroot.'donate.php'                                )

  ,new cNavbarLine( 1,  'Help &amp; Docs.'    ,'documents'   ,NULL                                                  )
  ,new cNavbarLine( 2,    'Infobase'          ,NULL          ,$infobaseroot                                         )
  ,new cNavbarLine( 3,      'Map tutorial'    ,NULL          ,$infobaseroot.'maped.tutorial.html'                   )
  ,new cNavbarLine( 3,      'Create Addons'   ,NULL          ,$infobaseroot.'adv.addons.html'                       )
  ,new cNavbarLine( 3,      'Configuration'   ,NULL          ,$infobaseroot.'intro.configuration.html'              )
# ,new cNavbarLine( 2,    'Online doc.'       ,NULL          ,$mainroot.'help/index.html'                           )
# ,new cNavbarLine( 3,      'Basic knowledg.' ,NULL          ,$mainroot.'help/basicknowledge.html'                  )
# ,new cNavbarLine( 3,      'Map tutorial'    ,NULL          ,$mainroot.'help/maptutorial/index.html'               )
# ,new cNavbarLine( 3,      'FAQ'             ,NULL          ,$mainroot.'help/faq/index.html'                       )
# ,new cNavbarLine( 3,      'Glossary'        ,NULL          ,$mainroot.'help/glossary/index.html'                  )
  ,new cNavbarLine( 2,    'Download Help'     ,NULL          ,$mainroot.'download.php#help'                         )
  ,new cNavbarLine( 2,    'Tutorials'         ,NULL          ,$mainroot.'tutorials.php'                             )
  ,new cNavbarLine( 2,    'Help forum'        ,NULL          ,$mainroot.'forums/index.php?board=4.0'                )

  ,new cNavbarLine( 1,  'Website'             ,'features'    ,NULL                                                  )
# ,new cNavbarLine( 2,    "Armin's..."        ,NULL          ,NULL                                                  )
# ,new cNavbarLine( 3,      'News'            ,NULL          ,$mainroot.'armin/index.shtm'                          )
# ,new cNavbarLine( 3,      'Advanced'        ,NULL          ,$mainroot.'armin/advanced.html'                       )
  ,new cNavbarLine( 2,    'InstaPolls'        ,NULL          ,$mainroot.'instapolls.php'                            )
  ,new cNavbarLine( 2,    'Layout'            ,NULL          ,$mainroot.'layout.php'                                )
  ,new cNavbarLine( 2,    'Stats'             ,NULL          ,$mainroot.'stats.php'                                 )
  ,new cNavbarLine( 2,    'Contact us'        ,NULL          ,$mainroot.'communication.php'                         )

  ,new cNavbarLine( 1,  'Community'           ,'community'   ,NULL                                                  )
  ,new cNavbarLine( 2,    'Links'             ,NULL          ,$mainroot.'links.php?showarchived=1'                  )
  ,new cNavbarLine( 2,    'People'            ,NULL          ,$mainroot.'people.php'                                )
# ,new cNavbarLine( 2,    'Companies'         ,NULL          ,$mainroot.'companies.php'                             )
# ,new cNavbarLine( 2,    'Engines'           ,NULL          ,$mainroot.'engines.php'                               )
# ,new cNavbarLine( 2,    'Interview'         ,NULL          ,$mainroot.'interview.php'                             )
  ,new cNavbarLine( 2,    'Communication'     ,NULL          ,NULL                                                  )
  ,new cNavbarLine( 3,      'Forums'          ,NULL          ,$mainroot.'communication.php#forums'                  )
# ,new cNavbarLine( 3,      'Mailing-lists'   ,NULL          ,$mainroot.'communication.php#mailinglist'             )
# ,new cNavbarLine( 3,      'Social media'    ,NULL          ,$mainroot.'communication.php#socialmedia'             )
  ,new cNavbarLine( 3,      'IRC / Chat'      ,NULL          ,$mainroot.'communication.php#chat'                    )
  ,new cNavbarLine( 3,      'Email'           ,NULL          ,$mainroot.'communication.php#webmaster'               )
  ,new cNavbarLine( 2,    'Misc. files'       ,NULL          ,NULL                                                  )
  ,new cNavbarLine( 3,      'User Prefabs'    ,NULL          ,$mainroot.'userprefabs.php'                           )
  ,new cNavbarLine( 3,      'User Maps'       ,NULL          ,$mainroot.'usermaps.php'                              )
  ,new cNavbarLine( 3,      'Videos'          ,NULL          ,$mainroot.'videos.php?*=1'                            )
# ,new cNavbarLine( 3,      'Submit'          ,NULL          ,$mainroot.'usermaps_submit.php'                       )
  ,new cNavbarLine( 2,    'Help needed'       ,NULL          ,NULL                                                  )
  ,new cNavbarLine( 3,      'Sugg. plug-ins'  ,NULL          ,$mainroot.'suggestedplugins.php'                      )
  ,new cNavbarLine( 3,      'Ad-Banners'      ,NULL          ,$mainroot.'adbanners.php'                             )
  ,new cNavbarLine( 3,      'Ad-Buttons'      ,NULL          ,$mainroot.'adbuttons.php'                             )

  ,new cNavbarLine( 1,  'Project Phoenix'     ,NULL          ,$mainroot.'quark7/index.php'                          )

# ,new cNavbarLine( 1,  'Beta test'           ,'beta'        ,NULL                                                  )
# ,new cNavbarLine( 2,    'Latest'            ,NULL          ,$mainroot.'latest/'                                   )
);

?>
