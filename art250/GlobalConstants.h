//
//  GlobalConstants.h
//  art250
//
//  Created by Winfred Raguini on 4/16/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#ifndef art250_GlobalConstants_h
#define art250_GlobalConstants_h

#define VESSEL_API_KEY @"WVU2UmhiUzBkTW5zcTdLRGpHRUk5Mm1s"

#define DEV_BASE_URL @"http://localhost:3000"
#define STAGING_BASE_URL @"http://gentle-journey-7944.herokuapp.com"
#define PROD_BASE_URL @"https://arttwo50.herokuapp.com"

#define kDefaultProfileImageURL @"/assets/fallback/default_profile.jpg"

#define SLOTVIEW_WIDTH 128.0f
#define SLOTVIEW_HEIGHT 98.0f

#define PROD_MIXPANEL_TOKEN @"397fda6303c5a07b29fe53092b6a695d"
#define DEV_MIXPANEL_TOKEN @"0de1848cc3bcac0a2079962284819ef5"

//Flurry
#define FLURRY_DEV_API_KEY @"MWWGXCZ48B255W7MY4B3"
#define FLURRY_PROD_API_KEY @"2HNVTVTBGJVSZ28DPHKC"


#define DEFAULT_BACKGROUND_IMAGE_FILENAME @"defaultBackgroundImage.jpg"

//NSUserDefaults keys
#define kFirstTimeAddedToCollectionKey @"kFirstTimeAddedToCollectionKey"
#define kTrackedArtPiecesKey @"kTrackedArtPiecesKey"
#define kNonFirstTimeUserKey @"kNonFirstTimeUserKey"
#define kFirstTimeUserKey @"kFirstTimeUserKey"
#define kdidImportArtistProfiles @"kdidImportArtistProfiles"
#define klastArtistProfileSyncDateKey @"klastArtistProfileSyncDate"
#define klastSizeChosenKey @"klastSizeChosenKey"
#define klastDistanceChosenKey @"klastDistanceChosenKey"

#define FACEBOOK_ENABLED @"facebook_enabled"
#define TWITTER_ENABLED @"twitter_enabled"

//Notification Events
#define kdidAddFirstArtworkToCollectionForNotification @"kdidAddFirstArtworkToCollectionForNotification"

//NSNotifications
#define kdidChooseTakeNewPhotoOptionNotification @"kdidChooseTakeNewPhotoOptionNotification"
#define kdidScrollArtForwardNotification @"kdidScrollArtForwardNotification"
#define kdidScrollArtBackwardNotification @"kdidScrollArtBackwardNotification"
#define kdidFillCollectionNotification @"kdidFillCollectionNotification"
#define kdidDismissFullCollectionAlertNotification @"kdidDismissFullCollectionAlertNotification"
#define kdidDismissCompletedPurchaseScreenNotification @"kdidDismissCompletedPurchaseScreenNotification"
#define kdidChooseCloseCameraButtonNotification @"kdidChooseCloseCameraButtonNotification"
#define kdidChooseNewPhotoOptionNotification @"kdidChooseNewPhotoOptionNotification"
#define kRetrieveSuggestedArtworkForSavedImgNotification @"kRetrieveSuggestedArtworkForSavedImgNotification"
#define kdidInvokeDeletingSharedImgForCartNotification @"kdidInvokeDeletingSharedImgForCartNotification"
#define kdidChooseSkipTourButtonNotification @"kdidChooseSkipTourButtonNotification"
#define kdidDisplayPurchaseScreenNotification @"kdidDisplayPurchaseScreenNotification"
#define kdidStartFirstTimeDirectionsTutorialNotification @"kdidStartFirstTimeDirectionsTutorialNotification"
#define kdidChooseTakeTourNotification @"kdidChooseTakeTourNotification"
#define kdidChooseEndTourButtonNotification @"kdidChooseEndTourButtonNotification"
#define kdidDismissShareScreenNotification @"kdidDismissShareScreenNotification"
#define kdidDismissCartViewNotification @"kdidDismissCartViewNotification"
#define kdidStartDisplayingDetailViewNotification @"kdidStartDisplayingDetailViewNotification"
#define kdidDismissDetailViewNotification @"kdidDismissDetailViewNotification"
#define kdidInvokeAppTourNotification @"kdidInvokeAppTourNotification"
#define kdidInvokeIntroNotification @"kdidInvokeIntroNotification"
#define kdidChangeCurrentArtworkNotification @"kdidChangeCurrentArtworkNotification"
#define kdidProgressThroughRecommendedArtworkNotification @"kdidProgressThroughRecommendedArtworkNotification"
#define kdidBeginDraggingArtworkNotification @"kdidBeginDraggingArtworkNotification"
#define kdidDisplayCollectionDockNotification @"kdidDisplayCollectionDockNotification"
#define kcollectionDockWillDisappearNotification @"kcollectionDockWillDisappearNotification"
#define kdidShowBottomToolbarNotification @"kdidShowBottomToolbarNotification"
#define kdidStopCheckoutTimerNotification @"kdidStopCheckoutTimerNotification"
#define kdidSaveMergedImageNotification @"kdidSaveMergedImageNotification"
#define kdidFailSavingMergedImageNotification @"kdidFailSavingMergedImageNotification"
#define kaddArtworkToCollectionNotification @"kaddArtworkToCollectionNotification"
#define kremoveArtworkFromCollectionNotification @"kremoveArtworkFromCollectionNotification"
#define kdidInvokeUpdateCollectionDockNotification @"kdidInvokeUpdateCollectionDockNotification"
#define kdidLoadSplashPageNotification @"kdidLoadSplashPageNotification"
#define kdidChooseBuyNowButtonNotification @"kdidChooseBuyNowButtonNotification"
#define kdidShowSignUpDialogNotification @"kdidShowSignUpDialogNotification"
#define kdidHideSignUpDialogNotification @"kdidHideSignUpDialogNotification"
#define kdidStartTourNotification @"kdidStartTourNotification"
#define kinvokeLaunchScreenSampleRoomNotification @"kinvokeLaunchScreenSampleRoomNotification"
#define kdidCloseArtworkDetailNotification @"kdidCloseArtworkDetailNotification"
#define kdidInvokeBuyOnShareScreenNotification @"kdidInvokeBuyOnShareScreenNotification"
#define kDidCreateNewCustomerSuccessfullyNotification @"kDidCreateNewCustomerSuccessfullyNotification"
#define kDidCreateNewCustomerFailedNotification @"kDidCreateNewCustomerFailedNotification"
#define kdidChooseMenuButtonNotification @"kdidChooseMenuButtonNotification"
#define kdidAddCurrentArtworkToCartNotification @"kdidAddCurrentArtworkToCartNotification"
#define kdidCompleteAddToCartAnimationNotification @"kdidCompleteAddToCartAnimationNotification"
#define kdidChooseShareButtonNotification @"kdidChooseShareButtonNotification"
#define kdidChooseCollectionFromPickerNotification @"kdidChooseCollectionFromPickerNotification"
#define kdidUpdateCarouselNotification @"kdidUpdateCarouselNotification"
#define kdidAddCurrentArtworkToCollectionNotification @"kdidAddCurrentArtworkToCollectionNotification"
#define kdidRetrieveAdditionalArtworkForArtistIDsNotification @"kdidRetrieveAdditionalArtworkForArtistIDsNotification"

//NSNotification - Signing in/signing out
#define kdidLogIntoFacebookNotification @"kdidLogIntoFacebookNotification"
#define kdidLogOutOfFacebookNotification @"kdidLogOutOfFacebookNotification"
#define kalreadyLoggedIntoFacebookNotification @"kalreadyLoggedIntoFacebookNotification"

#define kdidLogInWithEmailNotification @"kdidLogInWithEmailNotification"
#define kdidLogOutWithEmailNotification @"kdidLogOutWithEmailNotification"

#define kdidFailLoginNotification @"kdidFailLoginNotification"
#define kwillLogInNotification @"kwillLogInNotification"
#define kdidLoginNotification @"kdidLoginNotification"
#define kdidLogOutNotification @"kdidLogOutNotification"

#define kdidCancelSignInDialogNotification @"kdidCancelSignInDialogNotification"

//NSNotification - invocations
#define kdidInvokePurchaseScreenNotification @"kdidInvokePurchaseScreenNotification"
#define kdidInvokeFeedbackScreenNotification @"kdidInvokeFeedbackScreenNotification"
#define kdidInvokeTakePhotoNotification @"kdidInvokeTakePhotoNotification"
#define kdidInvokeShowBottomToolBarNotification @"kdidInvokeShowBottomToolBarNotification"
#define kdidInvokeShowSlotViewsNotification @"kdidInvokeShowSlotViewsNotification"
#define kdidInvokeHideMenuDockNotification @"kdidInvokeHideMenuDockNotification"
#define kdidInvokeUseSampleRoomNotification @"kdidInvokeUseSampleRoomNotification"
#define kdidInvokeChangeArtworkSizeNotification @"kdidInvokeChangeArtworkSizeNotification"
#define kdidInvokeImportPhotoNotification @"kdidInvokeImportPhotoNotification"
#define kdidInvokeLoadArtworkForArtistProfile @"kdidInvokeLoadArtworkForArtistProfile"

//Camera
#define kdidSelectCloseCameraButton @"kdidSelectCloseCameraButton"

//NSNotification UserInfo keys
#define kBackgroundImageKey @"kBackgroundImageKey"

//ARTtwo50

#define kdidCompleteChoosingOptionsForSampleRoom @"kdidCompleteChoosingOptionsForSampleRoom"
#define kdidInitializeArtworkNotification @"kdidInitializeArtworkNotification"
#define kdidCompleteLoadingAdditionalArtworkNotification @"kdidCompleteLoadingAdditionalArtworkNotification"

//system
#define kARTtwo50BuyerIdKey @"kARTtwo50BuyerIdKey"
#define kdidIncrementArtCounter @"kdidIncrementArtCounter"
#define kdidInteractWithApp @"kdidInteractWithApp"


//Artwork Collection
#define kArtworkDidGetDeletedFromCollection @"kArtworkDidGetDeletedFromCollection"
#define kArtworkDidGetAddedToCollection @"kArtworkDidGetAddedToCollection"
#define kTimerDidFireNotification @"kTimerDidFireNotification"

#define kDidChooseWallDistance @"kDidChooseWallDistance"
#define kdidLoadFinalIntroScreen @"kdidLoadFinalIntroScreen"
#define kdidSelectCameraButton @"kdidSelectCameraButton"
#define kdidRemoveFinalIntroScreen @"kdidRemoveFinalIntroScreen"
#define kdidDisplayNextPainting @"kdidDisplayNextPainting"
#define kwillDisplayNextPainting @"kwillDisplayNextPainting"


#define kdidPresentArtworkDetailView @"kdidPresentArtworkDetailView" 

#define kdidChooseContinueButton @"kdidChooseContinueButton"


#define kwillDismissArtworkPreview @"kwillDismissArtworkPreview"


#define kdidDismissHintsView @"kdidDismissHintsView"
#define kdidDismissTapAndDragScreen @"kdidDismissTapAndDragScreen"

//Server integration
#define kdidGetSuggestedArtworkFailure @"kdidGetSuggestedArtworkFailure"
#define kdidGetSuggestedArtworkSuccessfullyNotification @"kdidGetSuggestedArtworkSuccessfullyNotification"

#define kServerErrorKey @"kServerErrorKey"

//Credit card validation
#define kDidTokenizeCreditCard @"kDidTokenizeCreditCard"
#define kDidValidateCreditCardSuccessfully @"kDidValidateCreditCardSuccessfully"
#define kDidValidateCreditCardFailed @"kDidValidateCreditCardFailed"

#define kCreditCardAssociationFailedNotification @"kCreditCardAssociationFailedNotification"

#define kBPCardKey @"kBPCardKey"

#define kFBUsersKey @"kFBUsersKey"

//Sharing
#define kIsFacebookSharing @"kIsFacebookSharing"
#define kIsTwitterSharing @"kIsTwitterSharing"

//Walkthrough
#define kDidCompleteWalkthrough @"kDidCompleteWalkthrough"

//Tapping on main screen
#define kDidTapOnArtObject @"kDidTapOnArtObject"
#define kDidTapOnArtObjectInCollection @"kDidTapOnArtObjectInCollection"
#define kDidTapOnArtworkBackground @"kDidTapOnArtworkBackground"

//Balanced Payment Accounts
#define kBPCustomerKey @"kBPCustomerKey"
#define kBPCustomersKey @"kBPCustomersKey"
#define kBPAccountURIKey @"kBPAccountURIKey"
#define kBPCardsKey @"kBPCardsKey"
#define kBPEmailKey @"kBPEmailKey"
#define kBuyerIdKey @"kBuyerIdKey"

#define kdidSaveNewBPAccount @"kdidSaveNewBPAccount"

#define kshouldFreezeScreen  @"kshouldFreezeScreen"

#define SHARE_IMAGE_FILENAME_FORMAT @"hangit_%d.jpg"


#define kBackgroundImageOrientationKey @"kBackgroundImageOrientationKey"

/**************Flurry events *****************/
//Keys

#define kFlurryNumForwardSwipes @"kFlurryNumForwardSwipes"
#define kFlurryNumBackwardSwipes @"kFlurryNumBackwardSwipes"
#define kFlurryNumDetailViewsSeen @"kFlurryNumDetailViewsSeen"
#define kFlurryNumBioViewsSeen @"kFlurryNumBioViewsSeen"
#define kFlurryNumItemsAddedToCollection @"kFlurryNumItemsAddedToCollection"
#define kFlurryNumUniquePiecesSeen @"kFlurryNumUniquePiecesSeen"
#define kFlurryNumUpSwipes @"kFlurryNumUpSwipes"
#define kFlurryNumDownSwipes @"kFlurryNumDownSwipes"
#define kFlurryNumWallChanges @"kFlurryNumWallChanges"

//Collection
#define FL_COLLECTION_FILLED @"User has filled collection"


//Ask lizzy
#define FL_ASK_LIZZY_EMAIL_SEEN @"User views the ASK LIZZY email"
#define FL_ASK_LIZZY_SENT @"User sends an ASK LIZZY email"
#define FL_ASK_LIZZY_CANCELLED @"User cancels an ASK LIZZY email"

//App
#define FL_BEGAN_ARTTWO50_SESSION @"User started ARTtwo50 session"
#define FL_ATTEMPTED_TO_BUY_ART @"User tapped on buy art button at end of recs"
#define FL_ATTEMPTED_TO_ASK_LIZZY @"User tapped to ask lizzy at end of recs"
#define FL_REVIEWED_RECOMMENDATIONS @"User reviewed recommendations at end of recs"

//Walkthrough
#define FL_STARTED_INTRO @"User swipes to begin intro"
#define FL_SKIPS_INTRO @"User skips intro"
#define FL_USER_STARTS_APP_FIRST_TIME @"User starts app for the first time (stands up to take a photo)"
#define FL_VIEWED_INTRO_SLIDE @"User viewed an intro slide"

//FTD TOUR
#define FL_STARTED_FTD_TOUR @"User started first-time directions tour"

//Taking photo
#define FL_STARTED_TAKING_PHOTO @"User started taking a photo"
#define FL_TAPPED_SIZE_BTN @"User tapped size button"
#define FL_TAPPED_DISTANCE_BTN @"User tapped distance button"

//Sharing
#define FL_FACEBOOK_SHARE_SUCCESS @"FL_FACEBOOK_SHARE_SUCCESS"
#define FL_FACEBOOK_SHARE_FAIL @"FL_FACEBOOK_SHARE_FAIL"
#define FL_TWITTER_SHARE_SUCCESS @"FL_TWITTER_SHARE_SUCCESS"
#define FL_TWITTER_SHARE_FAIL @"FL_TWITTER_SHARE_FAIL"
#define FL_EMAIL_SHARE @"FL_EMAIL_SHARE"
#define USER_SHARED_SUCCESS @"User did successfully share"

//Checkout
#define FL_CART_BUTTON_SELECTED @"FL_CART_BUTTON_SELECTED"
#define FL_ARTWORK_FOR_CART_SELECTED @"FL_ARTWORK_FOR_CART_SELECTED"
#define FL_SHIPMENT_PAGE_VALIDATED @"FL_SHIPMENT_PAGE_VALIDATED"
#define FL_CREDIT_CARD_VALIDATED @"FL_CREDIT_CARD_VALIDATED"
#define FL_PURCHASE_COMPLETION_BUTTON_SELECTED @"FL_PURCHASE_COMPLETION_BUTTON_SELECTED"
#define FL_PURCHASE_COMPLETED @"FL_PURCHASE_COMPLETED"
#define FL_BUY_NOW_BUTTON_SELECTED @"User selected Buy Now button"
//Art
#define FL_REACHED_END_OF_REC @"Reached end of recommendations"
#define FL_GET_RECOMMENDED_ARTWORK @"Getting recommended art"
#define FL_GET_RECOMMENDED_ARTWORK_FAILED @"Getting recommended art FAILED"
#define FL_GET_RECOMMENDED_ARTWORK_SUCCESSFUL @"Getting recommended art SUCCEEDED"
#define FL_ART_SWIPES @"FL_ART_SWIPES"
#define FL_ART_ADDED_TO_COLLECTION @"FL_ART_ADDED_TO_COLLECTION"
#define FL_VIEW_FAVORITES @"User viewed favorites at end of carousel"

//Detailed View
#define FL_ARTWORK_DETAIL_VIEWED @"FL_ARTWORK_DETAIL_VIEWED"
#define FL_ARTIST_BIO_VIEWED @"FL_ARTIST_BIO_VIEWED"
#define FL_ARTWORK_DESCRIPTION_VIEWED @"FL_ARTWORK_DESCRIPTION_VIEWED"


//Settings
#define FL_FTD_TOUR_VIEWED @"User viewed FTD tour from settings"
#define FL_SETTINGS_SCREEN_DISPLAYED @"User views settings screen"
#define FL_BLOG_VIEWED @"User views blog"
#define FL_ABOUT_US_VIEWED @"User viewed About Us"
#define FL_FAQ_VIEWED @"User viewed FAQ"
#define FL_CONTACT_US_VIEWED @"User viewed Contact Us"
#define FL_RETURN_POLICY_VIEWED @"User viewed Return Policy"
#define FL_PRIVACY_POLICY_VIEWED @"User viewed Privacy Policy"
#define FL_TOS_VIEWED @"User viewed TOS"
#define FL_INTRO_VIDEOS_VIEWED @"User viewed Intro videos from settings"

//Vessel
#define VESSEL_ARTTWO50_SESSION @"User in an arttwo50 session"
#define VESSEL_CART_BUTTON_SELECTED @"User clicked on cart button"
#define VESSEL_CHECKOUT_SESSION @"User in checkout funnel"

#define VESSEL_COLLECTION_DOCK_CART_BUTTON_SELECTED @"User clicked on collection dock cart button"
#define VESSEL_MENU_DOCK_CART_BUTTON_SELECTED @"User clicked on menu dock cart button"

#define TR_STARTED_WITH_SAMPLE_ROOM @"User started using the app with a sample room"

#define USR_LOADED_FAV_IN_APP @"User loaded favorites from in-app (someone favorited your painting)"

#endif
