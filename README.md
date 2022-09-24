# Datingfoss

This is a Dating app that try to respect your privacy.

The main difference with other dating apps is that evry user has two kind of data:
- Public Data: are data that are visible to anyone else (like in most dating apps).
- Private Data: are data that are visible only to user that received a like from the owner of the data.

The main focus was to make the app work without letting the server know who put like on who and see the private data, in this way the user has to trust only the client code that can be verified and not the server.

This project started as a University project for the course Development and Implementation of a Mobile Application.

If you are interested in how the code is structured you can read the [DesignDocument](/design_document/DD.pdf) in this repo.


## Try the app

If you want to try the app you first need to:
- deploy the [server](https://github.com/fedeAlterio/DatingFoss.Server)
- run `flutter pub run mock_generator` to fill the sever with mock users
- start the app and login as Shaki with username `shaki` and password `shaki000` or signup