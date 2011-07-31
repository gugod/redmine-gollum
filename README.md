Redmine Gollum
==============

This is a plugin that let redmine project wiki be a gollum wiki.

Gollum is a wiki system that powers GitHub Wikis (https://github.com/github/gollum). Gollum Wiki plugin is a plugin that puts that power into Redmine.

A gollum wiki is a git repository that contains simple text files.

You can set a base path for all of your wikis if you want all wikis to be in the specific folder.

You can also go to project settings and set a custom wiki git path.

The wiki will be created when you go to a plugin tab. Old wikis will not be deleted or moved.


Be caution:

- The code is pretty alpha quality now, backward-incompatible changes are likely to be introduced in the future.
- It requires your redmine process (passenger / mongrel... whatever) to be able to write your git repositories
- Depending on your git server setup, you still need to configure the access control for the newly create wiki repositories
- IT DOES NOT IMPORT YOUR CURRENT WIKI CONTENT
- If you change the wiki path, it will NOT be moved
- You should have a plugin .git repository in vendor/plugins/redmine-gollum/.git
- Redmine Gollum will not warn you if you have files with the same name in one repo (but in different directories). Even if you set up different page files 	directory.
