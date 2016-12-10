WORKSPACE = KIWI.xcworkspace
PROJECT = KIWI.xcodeproj
SCHEME = "KIWI"

synxify:
	bundle exec synx $(PROJECT)

build:
	xcodebuild ONLY_ACTIVE_ARCH=NO -workspace $(WORKSPACE) -scheme $(SCHEME) -configuration Debug clean build | tee xcodebuild.log | xcpretty
