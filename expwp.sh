#!/bin/bash

# Ask for name
echo Hi, please enter the chosen directory name...
# Get name, save as variable
read varname

# Go into code directory
cd $HOME/code

# Create directory under chosen name
mkdir $varname

# Make vairable to hold location name aka, the root of this project.
LOC="$HOME/code/$varname"

# Start Mamp
open /Applications/MAMP\ PRO/MAMP\ PRO.app/
# Ask for confirmation of Mamp
echo "Hit return when Apache & MySQL are up and running in MAMP..."
read somethingelse

printf "
\n \n \n \n \n 
##################
\n 

Ok...\n
I'm just nipping off to grab a copy of Wordpress...\n
BRB.

\n
##################
\n \n \n \n \n"

# Enter newly created file
cd $LOC

# Check code folder for copy of WP
if [[ -f  $HOME/code/latest.tar.gz ]]; then
	cp -R $HOME/code/latest.tar.gz $LOC

else
	# Get Wordpress
	wget https://wordpress.org/latest.tar.gz
fi

# Extract wordpress from zip
tar -xzvf latest.tar.gz
# Remove zip folder
rm -rf latest.tar.gz
# Enter wordpress directory
cd $LOC/wordpress
# Move files to root folder
mv * $LOC
# Move up a directory to root folder
cd $LOC
# Remove redundent wordpress folder
rm -rf wordpress

printf "
\n \n \n \n \n 
##################
\n 

Ok...\n
Wordpress downloaded and unpacked. \n
I'll just grab our starter theme and child theme.

\n
##################
\n \n \n \n \n"

# Enter wordpress themes directory
cd $LOC/wp-content/themes
# Remove all existing theme directories
rm -r */

# Pull Git repository for GO
git clone http://github.com/expandia/go.git
# Pull git repository for go-child
git clone http://github.com/expandia/go-child.git
# Rename go-child to cliet name
mv go-child $varname

# Enter child directory
cd $LOC/wp-content/themes/$varname
# Remove link from child directory to git
rm -rf .git

printf "
\n \n \n \n \n 
##################
\n

Time to create our wp-config file and database, then install Wordpress!

\n
##################
\n \n \n \n \n"


# Create wp-config
wp core config --dbname=$varname --dbuser=localhost --dbpass=localhost --dbhost=localhost
# Create DB
wp db create
# Install WP
wp core install --url=localhost:8080 --title=$varname --admin_user=$varname --admin_password=$varname --admin_email=$varname@expandia.co
# Set theme to our child theme
wp theme activate $varname
# Set permalinks
wp rewrite structure '/%postname%' --hard
# Create home page
wp post create --post_type=page --post_title='Home' --page_template='templates/home.php' --post_status='publish'
# Create blog page
wp post create --post_type=page --post_title='Blog' --page_template='templates/blog-feed.php' --post_status='publish'
# Set static homepage for home and blog
wp option update page_on_front 3
wp option update page_for_posts 4
# Set option to show front page
wp option update show_on_front page

printf "
\n \n \n \n \n 
##################
\n

Two secs, I'll just grab the plugins and extract then activate them

\n
##################
\n \n \n \n \n"


# Get back to wp-content
cd $LOC/wp-content
# Remove current plugins
rm -rf plugins
# Get plugins
wget http://turbohope.co.uk/plugins.tar.gz
# Extract plugins
tar -xzvf plugins.tar.gz
# Remove redundant plugins zip
rm -rf plugins.tar.gz
# WP plugins
wp plugin activate --all
# Update all plugins
wp plugin update --all


printf "
\n \n \n \n \n 
##################
\n

Plugins are all installed and activated :)

\n
##################

\n \n \n \n \n"


# ----------------------

# Add pages

# ----------------------

for i in {1..20}
do
	echo "Want to add some pages? (y/n)"
	read pageBoolean
	
	if [ "$pageBoolean" = "y" ]; then
		
		echo "Enter page name"
		read pageName

		echo "Enter page template (home, about, contact or page)"
		read pageTemplate

		# Create Page
		wp post create --post_type=page --post_title=$pageName --page_template='templates/'$pageTemplate'.php' --post_status='publish'
	
	else
		break

	fi
done


# ----------------------

# Open in Sublime & Chrome

# ----------------------

# Get back into theme file
cd $LOC/wp-content/themes/$varname

echo "Do you want to open this project in Sublime? (y/n)"
read sublimeBoolean
if [ "$sublimeBoolean" = "y" ]; then
	# Open in sublime
	cd $LOC/wp-content/themes/$varname && subl .
fi

echo "Open in Chrome? (y/n)"
read chromeBoolean
if [ "$chromeBoolean" = "y" ]; then
	# Open in default browser
	open http://localhost:8080/wp-admin
fi


# ----------------------

# Start server

# ----------------------
# Change directory to root
cd $LOC
# Start WP server
wp server &