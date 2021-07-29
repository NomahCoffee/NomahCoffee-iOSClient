# NCUtils

A utility framework for all Nomah Coffee iOS host applications.

## Built With

This framework was build as a Cocoapod using Swift. It is a fairly scalable group of utility functions and classes to allow easy and quick building processes for all iOS applications in the Nomah Coffee portfolio.
* [Cocoapods](https://cocoapods.org)

## Getting Started (to work on / add to this framework)

Read more if you are looking to add to NCUtils

### Prerequisites

* Xcode - If you do not yet have Xcode, make sure to download it from the [App Store](https://apps.apple.com/us/app/xcode/id497799835?mt=12) (you will need a Mac for this).

### Installation

1. Clone the repo
   ```
   git clone https://github.com/NomahCoffee/NCUtils.git
   ``` 
2. Open the project with Xcode. You will notice two key folders (`NCUtils` and `NCUtilsExample` within the repository
   ```
   📦 NCUtils
      📂 NCUtils <- Right here...
      📂 NCUtilsTests
      📂 NCUtilsExample <- ...and here
      📄 Products
   ```
   * All of the work that will be wrapped in the framework will be inside of the `NCUtils` folder. When adding to or editing code within the framework, always make sure to build (cmd + B) while inside of the `NCUtils` scheme found in the top bar of Xcode.
   * You can use the `NCUtilsExample` folder to quickly and easily test anything you have added or changed within the framework itself. Just be sure to switch your scheme to `NCUtilsExample` and then you can run (cmd + R) the project.

### Contributing

If you have interest in contributing to this project, be sure to complete the following steps.
1. Follow steps #1 and #2 listed just above
2. Create a feature branch (`git checkout -b feature/YourFeature`)
3. Commit your changes (`git commit -m "Add some amazing feature"`)
4. Push to the branch (`git push origin feature/YourFeature`)
5. Open a pull request

### Release Process

This framework is not being distributed as a public Cocoapod, but rather, since it is to just be used across various Nomah Coffee iOS projects, NCUtils is being served up as a private pod. [Read more about private pods here](https://guides.cocoapods.org/making/private-cocoapods.html).

Given that NCUtils is a private pod, we need to include the [Nomah Coffee Private Spec Repo](https://github.com/NomahCoffee/NCPodspec) in the release process. Even though this is an slightly involved process to release a new version of this framework, here are the steps that you must take to do so.

1. Make sure all of your code changes / additions are fully made and tested within the example project within this repo
2. Make any necessary changes to the podspec file (found at `NCUtils/NCUtils.podspec`). You MUST update the version number within the podspec file at the very least.
3. Navigate to the root of this repo in your command line and run `pod lib lint`
   * If it passes, then you are all set to proceed
   * If it fails, make sure to address and issues and re-test them
4. Run `git add .` to add all files
5. Run `git commit -m [your commit message]` to commit your changes
6. Run `git tag [newest version number (make sure it matches the version number in the podspec file)]` to create the newest version
7. Run `git push --tags` to update the version number remotely
8. Run `git push` to push all of your changes to the remote repo

-- Its been pretty simple up to here, now we mix in the [Private Spec Repo](https://github.com/NomahCoffee/NCPodspec) --

9. Navigate to your local copy of `NCPodspec`, and specifically the `NCUtils` folder one level down from the root of the repo
10. Create a new folder with the same title as the new version number that you had just created
11. Copy the podspec folder that you edited in step 2 and copy and paste that into the newly created folder title by the new version number
12. Finally, commit these changes to the `NCPodspec` repo

## Getting Started (to inject / use this framework)

Read more if you are looking to use NCUtils in your iOS application

### Installation

1. Download `NCUtils` as a Cocoapod to your project by adding the following two lines to your `Podfile`
   ```
   source 'https://github.com/NomahCoffee/NCPodspec.git'
   ```
   This is needed because this framework is not public, so to use `NCUtils`, you must have access to the private pod spec, `NCPodspec`
   ```
   pod 'NCUtils'
   ``` 
   This grabs the `NCUtils` framework and downloads it to your iOS app
2. Use any of the utility work within this framework by adding the following import statement to any of the files in question
   ```
   import NCUtils
   ```
   
## Contact

Caleb Rudnicki - calebrudnicki@gmail.com

📍 Made in BOS
