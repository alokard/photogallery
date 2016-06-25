#import <Foundation/Foundation.h>
#import <Kiwi/Kiwi.h>
#import "FlickrAPIService.h"
#import "ConfigurationProtocol.h"
#import "ConfigurationKeys.h"
#import "FlickrAPIRequestSerializer.h"
#import "OHHTTPStubs.h"
#import "OHPathHelpers.h"
#import "RACSignal.h"
#import "RACSignal+Operations.h"
#import "RACMulticastConnection.h"
#import "PhotoSearchFlickrAPIResponse.h"
#import "Photo.h"

SPEC_BEGIN(FlickrAPIServiceSpec)

describe(@"FlickrAPIService", ^{
    __block FlickrAPIService *sut;

    beforeEach(^{
        KWMock <ConfigurationProtocol> *configurationMock = (KWMock <ConfigurationProtocol> *) [KWMock mockForProtocol:@protocol(ConfigurationProtocol)];
        [configurationMock stub:@selector(settingForKey:) withBlock:^id(NSArray *params) {
            return [params firstObject];
        }];

        sut = [[FlickrAPIService alloc] initWithConfiguration:configurationMock];
    });

    it(@"should init correctly", ^{
        NSURL *url = [NSURL URLWithString:ConfigurationKeys.baseURLString];
        url = [url URLByAppendingPathComponent:@""];
        [[sut.baseURL should] equal:url];
        [[sut.requestSerializer should] beKindOfClass:[FlickrAPIRequestSerializer class]];
    });

    context(@"General API requests", ^{
        beforeAll(^{
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                NSString *fixture = OHPathForFile(@"PhotoSearchResponse.json", self.class);
                return [OHHTTPStubsResponse responseWithFileAtPath:fixture
                                                        statusCode:200 headers:@{@"Content-Type" : @"application/json"}];
            }];
        });

        afterAll(^{
            [OHHTTPStubs removeAllStubs];
        });

        it(@"should send correct API request on search by text", ^{
            NSDictionary *finalRequestParams = @{
                    @"text" : @"test",
                    @"method" : @"flickr.photos.search"
            };
            [[sut should] receive:@selector(rac_GET:parameters:) withArguments:@"", finalRequestParams, nil];
            [sut searchPhotosWithText:@"test" tagsOnly:NO];
        });

        it(@"should parse search response correctly ", ^{
            __block PhotoSearchFlickrAPIResponse *apiResponse;
            [[sut searchPhotosWithText:@"test" tagsOnly:NO] subscribeNext:^(PhotoSearchFlickrAPIResponse *response) {
                apiResponse = response;
            }];

            [[expectFutureValue(apiResponse) shouldEventually] beKindOfClass:[PhotoSearchFlickrAPIResponse class]];
            [[expectFutureValue(apiResponse.page) shouldEventually] equal:@(1)];
            [[expectFutureValue(apiResponse.itemsPerPage) shouldEventually] equal:@(kFlickrAPIItemsPerPage)];
            [[expectFutureValue(apiResponse.totalPages) shouldEventually] equal:@(9)];
            [[expectFutureValue(apiResponse.totalItems) shouldEventually] equal:@(808)];
            [[expectFutureValue(apiResponse.photos) shouldNotEventually] beEmpty];
            [[expectFutureValue(apiResponse.photos) shouldEventually] haveCountOf:100];
            [[expectFutureValue(apiResponse.photos.firstObject) shouldEventually] beMemberOfClass:[Photo class]];
        });

    });
});

SPEC_END
