#import "XMPP.h"

#ifdef HAVE_XMPP_SUBSPEC_BANDWIDTHMONITOR
#import "XMPPBandwidthMonitor.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_GOOGLESHAREDSTATUS
#import "XMPPGoogleSharedStatus.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_RECONNECT
#import "XMPPReconnect.h"
#endif

//#ifdef HAVE_XMPP_SUBSPEC_ROSTER
#import "XMPPRoster.h"
#import "XMPPAutoPing.h"             //重连使用
#import "XMPPReconnect.h"            //重连使用
#import "XMPPRosterMemoryStorage.h"  //遵循 XMPPRosterStorage接口
#import "XMPPUserMemoryStorageObject.h" //遵循 XMPPUser接口
#import "XMPPvCardAvatarModule.h"    //头像
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPvCardTemp.h"

#import "XMPPRoomCoreDataStorage.h"

//聊天记录模块
#import "XMPPMessageArchiving.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPMessageArchiving_Contact_CoreDataObject.h" //最近联系人
#import "XMPPMessageArchiving_Message_CoreDataObject.h"

//#endif

#ifdef HAVE_XMPP_SUBSPEC_SYSTEMINPUTACTIVITYMONITOR
#import "XMPPSystemInputActivityMonitor.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0009
#import "XMPPJabberRPCModule.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0012
#import "XMPPLastActivity.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0016
#import "XMPPPrivacy.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0045
#import "XMPPMUC.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0045
#import "XMPPRoom.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0054
#import "XMPPvCardTempModule.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0060
#import "XMPPPubSub.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0100
#import "XMPPTransports.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0115
#import "XMPPCapabilities.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0136
#import "XMPPMessageArchiving.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0153
#import "XMPPvCardAvatarModule.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0184
#import "XMPPMessageDeliveryReceipts.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0191
#import "XMPPBlocking.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0198
#import "XMPPStreamManagement.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0199
#import "XMPPAutoPing.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0199
#import "XMPPPing.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0202
#import "XMPPAutoTime.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0202
#import "XMPPTime.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0224
#import "XMPPAttentionModule.h"
#endif

#ifdef HAVE_XMPP_SUBSPEC_XEP_0280
#import "XMPPMessageCarbons.h"
#endif
