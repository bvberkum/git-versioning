Install ::

  $ make install
  $ make uninstall

or::

  @ENV_NAME=production ./configure.sh /usr/local
  @ENV_NAME=production sudo ./install.sh uninstall
  @ENV_NAME=production sudo ./install.sh install


See also Travis CI test build script.


Two options per project

1. .versioned-files.list file, starting with the main-document and followed
   by other files::

      cd myproject
      echo my-project > .app-id
      echo :Version: 0.0.1  > ReadMe.rst
      echo "# Id: my-project" > test.sh
      echo 'version=0.0.1 # my-project' >> test.sh
      echo -e '{\n"version":"0.0.1"\n}' > package.json
      echo ReadMe.rst > .versioned-files.list
      echo package.json >> .versioned-files.lst
      echo test.sh >> .versioned-files.lst


2. .version-attributes to customize main-document, list-file, and other
   settings::

      App-Id: git-versioning
      # Version:
      Main-File: ReadMe.rst
      # Formats: /src/github.com/bvberkum/git-versioning/lib/formats.sh
      # Local-Formats: local-formats.sh
      # File-List: .versioned-files.list
      # Other-Files:

Usage examples::

  git-versioning check # verify all versions match
  git-versioning dev # apply dev tag
  git-versioning snapshot # apply feature tag
  git-versioning update # rewrite embedded versions
  git-versioning check


Syntax
------
For clike or hash-comment languages::

  # Id: app-id/0.0.0 path/filename.ext
  # version: 0.0.0 app-id path/filename.ext

And while the exact format differs they follow the pattern::

  version = 0.0.0 # app-id

For some files exceptions are made. Refer to test/example files for syntax
per format.

The app-id is included to avoid any ambiguity.
Exact specs of variable rewrites may differ per format since its not always
possible to include a comment on the line (ie. JSON).


rSt example::

  .. Id: git-versioning/0.2.0-dev ReadMe.rst


Use cases
---------

1. files get distributed, and need to be matched to source repository easily
2. file need access to the project's version (ie. compiled program source code)
   and such versions need to be updated.

Issues
------

Only the first match in a version is considered. This for me is a minor issue,
one I may get to fix later. However, more important to me are some
considerations with regard to source code versioning.

Without deployment, embedding version strings as file Id's always adds a change.
SCM systems may not have facilities to ignore lines, and anyway looking at such
changeset is not informative at all.

In my opinion

1. changes to versions should be left out of the source code and out of version
   history as much as possible. I think it would be more appropiate to use a
   placeholder that does not change (as much).

2. when committing a release, the commit may be left out of the default SCM
   version. On a seperate branch or even without any branch only a commit.
   Such version could even have a tag to distinguish it from a related version
   tagged onto the default or main-line branch. This way versions appear on the
   main line too, which helps to navigate the repository.

That said, having the project version embedded makes some sense to me, and
having another script to help with copies has some place. For compiled projects,
it can be more convienient to copy the version rather than add the overhead to
retrieve them during the build process. For documentation it may not be pretty
or informative to look at a placeholder. And a build system with documentation
distribution is not feasible for every project, some may want to try to get as
much from the SCM system instead, including serving documentation.

More on current issues in `dev doc <./dev.rst>`_.
