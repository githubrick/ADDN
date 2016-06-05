# ADDN

Devices Requirement: iPhone 4S, iPhone 5/5s, iPhone 6/6s

To run this application, the local server need to be installed and set. The steps are as followed:
1. Install XAMPP in the apple store.
2. Copy the file in API(the name is “project”) into the server apache html root directory (normally in your MAC: Applications/XAMPP/htdocs/).
3. Create a database(better set the database name of “ADDN”) and import the Database(ADDN.sql) (Use phpmyadmin in browser you just installed).
4.Change api config files(api_config.php and config.ini which are in the file of project) to your database username, password and dbname if you are not in the default settings.(the default setting is username: root, password:, dbname: ADDN ).

Then you can run the application in Xcode. You can do as followed in the first time:
1. Login (username: Testuser3, password:987654 and Testuser3’s centre is QLD_BNE_LCH (Lady Cliento Children’s Hospital))
2. Click the top right corner button to load the dashboard data.

To use the nofitication function of the App, run the API php file on server:
php api.php
php push.php development
