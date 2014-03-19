Python-SPSS-AlamedaCounty
=========================

This is the system and select code that creates the Alameda County Health Care Dashboards

Update pip_ and then setuptools

.. _pip: http://www.pip-installer.org/en/latest/installing.html

$ pip install --upgrade setuptools


create and activate the venv

open the main app directory

$ virtualenv .

$ source bin/activate


pip install the requirements

$ pip install -r requirements.txt --upgrade

If installation is a pain try this

$ pip install --allow-all-external --upgrade -r requirements.txt

If you are getting the error "ImportError: No module named setuptools" see this ImportError_ fix

.. _ImportError: https://github.com/pypa/pip/issues/1064

in addition, you need psexec from 
http://technet.microsoft.com/en-us/sysinternals/bb897553.aspx

this file also in k:/xpyinstals/psexec/

passwords-
set environment variable mypassword={your password}

add (with your paths changed) the paths to executables in your path environment variable: 
;C:\Python27\Lib\site-packages\;C:\Python27\;C:\Python27\Scripts\;k:\meinzer\production\ps\;C:\Users\meinzerc\Documents\PSTools\