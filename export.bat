@echo off


REM BATCH CALL :
REM export.bat ProjectPath sourceFolder webFolder outputFolder

REM EXEMPLE :
REM export.bat C:\symfony\Symfony_TestProject src public output


REM GLOBAL CONFIG VARS
REM -------------------------
REM project path
set vendor=C:\dev\vendor
set index=index.html
REM -------------------------

REM GLOBAL ARGUMENTS
REM -------------------------
REM project path
set project=%1
REM project file path to analyze
set src=%2
REM project file path to analyze
set web=%3
REM project output path
set out=%4
REM -------------------------

REM EXEMPLE :
REM -------------------------
REM set project=C:\symfony\Symfony_TestProject
REM set src=src
REM set web=public
REM set out=output
REM -------------------------

REM VARIABLE REWRITE
REM -------------------------
set srcfull=%project%\%src%
set webfull=%project%\%web%
set outfull=%project%\%web%\%out%
set export=%outfull%\%index%
REM -------------------------

echo .
echo ##################
echo ## SCRIPT START ##
echo ##################
echo .

break>%export%
mkdir %outfull%


echo ^<html^>^<body^> > %export%

echo ------------------------------
echo ----Processing PHP Metrics----
echo ------------------------------
echo .
echo %vendor%\phpmetrics\phpmetrics\bin\phpmetrics --report-html=%outfull%\phpmetrics.html %srcfull%
echo .
php %vendor%\phpmetrics\phpmetrics\bin\phpmetrics --report-html=%outfull%\phpmetrics.html %srcfull% 2>null
echo ^<h1^>PHP Metrics^</h1^> >> %export%
echo ^<a href="/%out%/phpmetrics.html"^>PHP Metrics results^</a^> >> %export%

echo ------------------------------
echo --Processing PHP CodeSniffer--
echo ------------------------------
echo .
echo %vendor%\squizlabs\php_codesniffer\bin\phpcs -s --standard=PSR2 --report=summary %srcfull%
echo .
echo ^<h1^>PHP CodeSniffer^</h1^> >> %export%
echo ^<pre^> >> %export%
php %vendor%\squizlabs\php_codesniffer\bin\phpcs -s --standard=PSR2 --report=summary %srcfull% >> %export% 2>null
echo ^</pre^> >> %export%

echo ------------------------------------
echo --Processing PHP CopyPasteDetector--
echo ------------------------------------
echo .
echo %vendor%\sebastian\phpcpd\phpcpd %srcfull%
echo .
echo ^<h1^>PHP CopyPasteDetector^</h1^> >> %export%
echo ^<pre^> >> %export%
php %vendor%\sebastian\phpcpd\phpcpd %srcfull% >> %export% 2>null
echo ^</pre^> >> %export%

echo "------------------------------"
echo "-Processing  PHP MessDetector-"
echo "------------------------------"
echo .
echo php %vendor%\phpmd\phpmd\src\bin\phpmd %srcfull% text cleancode,codesize,controversial,design,naming,unusedcode
echo .
echo ^<h1^>PHP MessDetector^</h1^> >> %export%
echo ^<pre^> >> %export%
php %vendor%\phpmd\phpmd\src\bin\phpmd %srcfull% text cleancode,codesize,controversial,design,naming,unusedcode >> %export% 2>null
echo ^</pre^> >> %export%

echo "------------------------------"
echo "----Processing  PHP Depend----"
echo "------------------------------"
echo .
echo php %vendor%\pdepend\pdepend\src\bin\pdepend --summary-xml=%outfull%\summary.xml --jdepend-chart=%outfull%\jdepend.svg --overview-pyramid=%outfull%\pyramid.svg %srcfull%
echo .
echo ^<h1^>PHP Depend^</h1^> >> %export%
php %vendor%\pdepend\pdepend\src\bin\pdepend --summary-xml=%outfull%\summary.xml --jdepend-chart=%outfull%\jdepend.svg --overview-pyramid=%outfull%\pyramid.svg %srcfull% 2>null
echo ^<h2^>Depend^</h2^> >> %export%
echo ^<img src="/%out%/jdepend.svg"/^> >> %export%
echo ^<h2^>Pyramid^</h2^> >> %export%
echo ^<img src="/%out%/pyramid.svg"/^> >> %export%

echo ^</body^>^</html^> >> %export%

echo . 
echo #################
echo ## SCRIPT DONE ##
echo #################
echo . 
echo Result should be available at the url /%out%/%index% of your project
