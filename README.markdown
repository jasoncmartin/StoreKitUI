StoreKitUI
==========

StoreKitUI is an iPhone library that allows for a simple front-end for StoreKit. Simply add this library to your project, and push the SKStoreViewController on the navigation stack, and you're good to go! More info on the API and examples will be published in the future.

Adding StoreKitUI to your project
=================================

StoreKitUI is compiled as a static library, and the easiest way to add it to your project is to use Xcode's "dependent project" facilities.  Here is how:

1. Clone the StoreKitUI git repository: `git clone git://github.com/jasoncmartin/StoreKitUI.git`.  Make sure 
   you store the repository in a permanent place because Xcode will need to reference the files
   every time you compile your project.

2. Locate the "StoreKitUI.xcodeproj" file under "StoreKitUI/src".  Drag StoreKitUI.xcodeproj and drop it onto
   the root of your Xcode project's "Groups and Files"  sidebar.  A dialog will appear -- make sure 
   "Copy items" is unchecked and "Reference Type" is "Relative to Project" before clicking "Add".

3. Now you need to link the StoreKitUI static library to your project.  Click the "StoreKitUI.xcodeproj" 
   item that has just been added to the sidebar.  Under the "Details" table, you will see a single
   item: libStoreKitUI.a.  Check the checkbox on the far right of libStoreKitUI.a.

4. Now you need to add StoreKitUI as a dependency of your project, so Xcode compiles it whenever
   you compile your project.  Expand the "Targets" section of the sidebar and double-click your
   application's target.  Under the "General" tab you will see a "Direct Dependencies" section. 
   Click the "+" button, select "StoreKitUI", and click "Add Target".

5. Finally, we need to tell your project where to find the StoreKitUI headers.  Open your
   "Project Settings" and go to the "Build" tab. Look for "Header Search Paths" and double-click
   it.  Add the relative path from your project's directory to the "StoreKitUI/src" directory.

6. While you are in Project Settings, go to "Other Linker Flags" under the "Linker" section, and
   add "-ObjC" and "-all_load" to the list of flags.

7. You're ready to go.  Just #import "StoreKitUI/StoreKitUI.h" anywhere you want to use StoreKitUI classes
   in your project.