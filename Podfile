# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'reminderSimple' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!  

  # Pods for reminderSimple
  pod 'Realm', :git => 'https://github.com/realm/realm-cocoa.git', :branch => 'master', :submodules => true
  pod 'RealmSwift', :git => 'https://github.com/realm/realm-cocoa.git', :branch => 'master', :submodules => true
  pod 'Firebase/Core'
  pod 'Firebase/AdMob'

  target 'reminderSimpleTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Realm', :git => 'https://github.com/realm/realm-cocoa.git', :branch => 'master', :submodules => true
    pod 'RealmSwift', :git => 'https://github.com/realm/realm-cocoa.git', :branch => 'master', :submodules => true
    pod 'Firebase/Core'
    pod 'Firebase/AdMob'
  end

  target 'reminderSimpleUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
