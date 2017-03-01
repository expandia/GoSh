#!/bin/bash

echo Hi, please enter the chosen directory name...

# Declare file name as varname variable
read varname

# Create directory under chosen name
mkdir $varname

# Start Mamp
open /Applications/MAMP\ PRO/MAMP\ PRO.app/

# Ask for confirmation of Mamp
echo Is Mamp running Y/N
read somethingelse

# Enter newly created file
cd $varname

# Wget the required wordpress template
wget https://wordpress.org/latest.tar.gz

# Extract wordpress from zip
tar -xzvf latest.tar.gz

# Remove zip folder
rm -rf latest.tar.gz

# Enter wordpress directory
cd wordpress

# Move files to root folder
mv * ../

# Move up a directory to root folder
cd ../

# Remove redundent wordpress folder
rm -rf wordpress

# Enter wordpress themes directory
cd wp-content/themes

# Remove all existing theme directories
rm -r */

# Pull Git repository for GO
git clone http://github.com/expandia/go.git

# Pull git repository for go-child
git clone http://github.com/expandia/go-child.git

# Rename go-child to cliet name
mv go-child $varname

# Enter child directory
cd $varname

# Remove link from child directory to git
rm -rf .git

# Create wp-config
wp core config --dbname=$varname --dbuser=localhost --dbpass=localhost --dbhost=localhost

# Create DB
wp db create

# Install WP
wp core install --url=localhost --title=$varname --admin_user=$varname --admin_password=$varname --admin_email=$varname@expandia.co

# Open in sublime
subl .

# Open in default browser
open http://localhost:8080

# Start WP server
cd ../../../
wp server