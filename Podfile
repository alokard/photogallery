platform :ios, '8.0'

inhibit_all_warnings!

def shared_pods
	pod 'Overcoat/ReactiveCocoa'
end

target :PhotoGallery, :exclusive => true do
	shared_pods

	pod 'PINRemoteImage'
	pod 'Masonry'
end

target :PhotoGalleryTests, :exclusive => true do
	shared_pods

	pod 'OHHTTPStubs'
	pod 'Kiwi'
end