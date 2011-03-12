Redmine Gollum
==============

This is a plugin that let redmine project wiki be a gollum wiki.

You need to set the value of `gollum.repository_root` in your `config/configration.yml` file.

For example, if you are using gitosis, this might be a good working setting:

    production:
      gollum:
        repository_root: /home/git/repositories

The project wiki repository will be named after the project identifier
(not name) plus `.wiki.git` suffix.  For example, `redgolf.wiki.git`
is the repository name of the project `redgolf`.

Be caution:

- The code is pretty alpha quality now, backward-incompatible changes are likely to be introduced in the future.
- It only support markdown (at the moment)
- It requires your redmine process (passenger / mongrel... whatever) to be able to write your git repositories
- Depending on your git server setup, you still need to configure the access control for the newly create wiki repositories
- IT DOES NOT IMPORT YOUR CURRENT WIKI CONTENT


