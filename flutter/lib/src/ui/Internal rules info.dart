import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;


class InternalRules extends StatefulWidget {
  @override
  StoryTellerSettings createState() => new StoryTellerSettings();
}

class StoryTellerSettings extends State<InternalRules> {
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                elevation: 1.0,
                expandedHeight: kToolbarHeight,
                pinned: true,
                floating: true,
                title: Text(
                  'Internal Rules',
                  style: TextStyle(
                    fontFamily: 'SFProDisplayBold',
                    fontSize: 25.0,
                  ),
                ),
                centerTitle: true,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(
                      height: 0,
                    ),
                    

 
	  Html(
                data: """
                </br>
               

<h3><strong>The Teling Service</strong></h3>



<p>We agree to provide you with the Teling Service. The Service includes all of the Teling products, features, applications, services, technologies, and software that we provide to advance Teling's mission: To bring you closer to the people and things you love. The Service is made up of the following aspects (the Service):</p>

<ul><li><strong>Offering personalized opportunities to create, connect, communicate, discover, and share.</strong><br>People are different. We want to strengthen your relationships through shared experiences you actually care about. So we build systems that try to understand who and what you and others care about, and use that information to help you create, find, join, and share in experiences that matter to you. Part of that is highlighting content, features, offers, and accounts you might be interested in, and offering ways for you to experience Teling, based on things you and others do on and off Teling.</li><li><strong>Fostering a positive, inclusive, and safe environment.</strong><br>We develop and use tools and offer resources to our community members that help to make their experiences positive and inclusive, including when we think they might need help. We also have teams and systems that work to combat abuse and violations of our Terms and policies, as well as harmful and deceptive behavior. We use all the information we have-including your information-to try to keep our platform secure. We also may share information about misuse or harmful content with other  Companies or law enforcement. Learn more in the Data Policy.</li><li><strong>Developing and using technologies that help us consistently serve our growing community.</strong><br>Organizing and analyzing information for our growing community is central to our Service. A big part of our Service is creating and using cutting-edge technologies that help us personalize, protect, and improve our Service on an incredibly large scale for a broad global community. Technologies like artificial intelligence and machine learning give us the power to apply complex processes across our Service. Automated technologies also help us ensure the functionality and integrity of our Service.</li><li><strong>Providing consistent and seamless experiences across other  Company Products.</strong><br>Teling is part of the  Companies, which share technology, systems, insights, and information-including the information we have about you (learn more in the Data Policy) in order to provide services that are better, safer, and more secure. We also provide ways to interact across the  Company Products that you use, and designed systems to achieve a seamless and consistent experience across the  Company Products.</li><li><strong>Ensuring a stable global infrastructure for our Service.</strong><br>To provide our global Service, we must store and transfer data across our systems around the world, including outside of your country of residence. This infrastructure may be owned or operated by  Inc.,  Ireland Limited, or their affiliates.</li><li><strong>Connecting you with brands, products, and services in ways you care about.</strong><br>We use data from Teling and other  Company Products, as well as from third-party partners, to show you ads, offers, and other sponsored content that we believe will be meaningful to you. And we try to make that content as relevant as all your other experiences on Teling.</li><li><strong>Research and innovation.</strong><br>We use the information we have to study our Service and collaborate with others on research to make our Service better and contribute to the well-being of our community.</li></ul>



<h3><strong>The Data Policy</strong></h3>



<p>Providing our Service requires collecting and using your information. The Data Policy explains how we collect, use, and share information across the  Products. It also explains the many ways you can control your information, including in the Teling Privacy and Security Settings.</p>


<!-- wp:heading {"level":3} -->
<h3><strong>Your Commitments</strong></h3>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>In return for our commitment to provide the Service, we require you to make the below commitments to us.&nbsp;<strong>Who Can Use Teling.</strong>&nbsp;We want our Service to be as open and inclusive as possible, but we also want it to be safe, secure, and in accordance with the law. So, we need you to commit to a few restrictions in order to be part of the Teling community.&nbsp;</p>
<!-- /wp:paragraph -->

<!-- wp:list -->
<ul><li>You must be at least 12 years old.</li><li>You must not be prohibited from receiving any aspect of our Service under applicable laws or engaging in payments related Services if you are on an applicable denied party listing.</li><li>We must not have previously disabled your account for violation of law or any of our policies.</li><li>You must not be a convicted sex offender.</li></ul>
<!-- /wp:list -->

<!-- wp:paragraph -->
<p><strong>How You Can't Use Teling.</strong>&nbsp;Providing a safe and open Service for a broad community requires that we all do our part.&nbsp;</p>
<!-- /wp:paragraph -->

<!-- wp:list -->
<ul><li><strong>You can't impersonate others or provide inaccurate information.</strong><br>You don't have to disclose your identity on Teling, but you must provide us with accurate and up to date information (including registration information). Also, you may not impersonate someone you aren't, and you can't create an account for someone else unless you have their express permission.</li><li><strong>You can't do anything unlawful, misleading, or fraudulent or for an illegal or unauthorized purpose.</strong></li><li><strong>You can't violate (or help or encourage others to violate) these Terms or our policies, including in particular the Teling Community Guidelines, Teling Platform Policy, and Music Guidelines.</strong> Learn how to report conduct or content in our Help Center.</li><li><strong>You can't do anything to interfere with or impair the intended operation of the Service.</strong></li><li><strong>You can't attempt to create accounts or access or collect information in unauthorized ways.</strong><br>This includes creating accounts or collecting information in an automated way without our express permission.</li><li><strong>You can't attempt to buy, sell, or transfer any aspect of your account (including your username) or solicit, collect, or use login credentials or badges of other users.</strong></li><li><strong>You can't post private or confidential information or do anything that violates someone else's rights, including intellectual property.</strong><br>Learn more, including how to report content that you think infringes your intellectual property rights.</li><li><strong>You can't use a domain name or URL in your username without our prior written consent.</strong></li></ul>
<!-- /wp:list -->

<!-- wp:paragraph -->
<p><strong>Permissions You Give to Us.</strong>&nbsp;As part of our agreement, you also give us permissions that we need to provide the Service.&nbsp;</p>
<!-- /wp:paragraph -->

<!-- wp:list -->
<ul><li><strong>We do not claim ownership of your content, but you grant us a license to use it.</strong><br>Nothing is changing about your rights in your content. We do not claim ownership of your content that you post on or through the Service. Instead, when you share, post, or upload content that is covered by intellectual property rights (like photos or videos) on or in connection with our Service, you hereby grant to us a non-exclusive, royalty-free, transferable, sub-licensable, worldwide license to host, use, distribute, modify, run, copy, publicly perform or display, translate, and create derivative works of your content (consistent with your privacy and application settings). You can end this license anytime by deleting your content or account. However, content will continue to appear if you shared it with others and they have not deleted it. To learn more about how we use information, and how to control or delete your content, review the Data Policy and visit the Teling Help Center.</li><li><strong>Permission to use your username, profile picture, and information about your relationships and actions with accounts, ads, and sponsored content.</strong><br>You give us permission to show your username, profile picture, and information about your actions (such as likes) or relationships (such as follows) next to or in connection with accounts, ads, offers, and other sponsored content that you follow or engage with that are displayed on  Products, without any compensation to you. For example, we may show that you liked a sponsored post created by a brand that has paid us to display its ads on Teling. As with actions on other content and follows of other accounts, actions on sponsored content and follows of sponsored accounts can be seen only by people who have permission to see that content or follow. We will also respect your ad settings. You can learn more about your ad settings.</li><li><strong>You agree that we can download and install updates to the Service on your device.</strong></li></ul>
<!-- /wp:list -->

<!-- wp:heading {"level":3} -->
<h3><strong>Additional Rights We Retain</strong></h3>
<!-- /wp:heading -->

<!-- wp:list -->
<ul><li>If you select a username or similar identifier for your account, we may change it if we believe it is appropriate or necessary (for example, if it infringes someone's intellectual property or impersonates another user).</li><li>If you use content covered by intellectual property rights that we have and make available in our Service (for example, images, designs, videos, or sounds we provide that you add to content you create or share), we retain all rights to our content (but not yours).</li><li>You can only use our intellectual property and trademarks or similar marks as expressly permitted by our Brand Guidelines or with our prior written permission.</li><li>You must obtain written permission from us or under an open source license to modify, create derivative works of, decompile, or otherwise attempt to extract source code from us.</li></ul>
<!-- /wp:list -->

<!-- wp:heading {"level":3} -->
<h3><strong>Content Removal and Disabling or Terminating Your Account</strong></h3>
<!-- /wp:heading -->

<!-- wp:list -->
<ul><li>We can remove any content or information you share on the Service if we believe that it violates these Terms of Use, our policies (including our Teling Community Guidelines), or we are required to do so by law. We can refuse to provide or stop providing all or part of the Service to you (including terminating or disabling your account) immediately if you: clearly, seriously or repeatedly violate these Terms of Use, our policies (including our Teling Community Guidelines), if you repeatedly infringe other people's intellectual property rights, or where we are required to do so by law. If we take action to remove your content for violating our Community Guidelines, or disable or terminate your account, we will notify you where appropriate. If you believe your account has been terminated in error, or you want to disable or permanently delete your account, consult our Help Center.</li><li>Content you delete may persist for a limited period of time in backup copies and will still be visible where others have shared it. This paragraph, and the section below called "Our Agreement and What Happens if We Disagree," will still apply even after your account is terminated or deleted.</li></ul>
<!-- /wp:list -->

<!-- wp:heading {"level":3} -->
<h3><strong>Our Agreement and What Happens if We Disagree</strong></h3>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p><strong>Our Agreement.</strong></p>
<!-- /wp:paragraph -->

<!-- wp:list -->
<ul><li>Your use of music on the Service is also subject to our Music Guidelines, and your use of our API is subject to our Platform Policy. If you use certain other features or related services, you will be provided with an opportunity to agree to additional terms that will also become a part of our agreement. For example, if you use payment features, you will be asked to agree to the Community Payment Terms. If any of those terms conflict with this agreement, those other terms will govern.</li><li>If any aspect of this agreement is unenforceable, the rest will remain in effect.</li><li>Any amendment or waiver to our agreement must be in writing and signed by us. If we fail to enforce any aspect of this agreement, it will not be a waiver.</li><li>We reserve all rights not expressly granted to you.</li></ul>
<!-- /wp:list -->

<!-- wp:paragraph -->
<p><strong>Who Has Rights Under this Agreement.</strong></p>
<!-- /wp:paragraph -->

<!-- wp:list -->
<ul><li>This agreement does not give rights to any third parties.</li><li>You cannot transfer your rights or obligations under this agreement without our consent.</li><li>Our rights and obligations can be assigned to others. For example, this could occur if our ownership changes (as in a merger, acquisition, or sale of assets) or by law.</li></ul>
<!-- /wp:list -->

<!-- wp:paragraph -->
<p><strong>Who Is Responsible if Something Happens.</strong></p>
<!-- /wp:paragraph -->

<!-- wp:list -->
<ul><li>We will use reasonable skill and care in providing our Service to you and in keeping a safe, secure, and error-free environment, but we cannot guarantee that our Service will always function without disruptions, delays, or imperfections. Provided we have acted with reasonable skill and care, we do not accept responsibility for: losses not caused by our breach of these Terms or otherwise by our acts; losses which are not reasonably foreseeable by you and us at the time of entering into these Terms; any offensive, inappropriate, obscene, unlawful, or otherwise objectionable content posted by others that you may encounter on our Service; and events beyond our reasonable control.</li><li>The above does not exclude or limit our liability for death, personal injury, or fraudulent misrepresentation caused by our negligence. It also does not exclude or limit our liability for any other things where the law does not permit us to do so.&nbsp;</li></ul>
<!-- /wp:list -->

<!-- wp:paragraph -->
<p><strong>How We Will Handle Disputes.</strong></p>
<!-- /wp:paragraph -->

<!-- wp:quote -->
<blockquote class="wp-block-quote"><p>If you are a consumer and habitually reside in a Member State of the European Union, the laws of that Member State will apply to any claim, cause of action, or dispute you have against us that arises out of or relates to these Terms ("claim"), and you may resolve your claim in any competent court in that Member State that has jurisdiction over the claim. In all other cases, you agree that the claim must be resolved in a competent court in the Republic of Ireland and that Irish law will govern these Terms and any claim, without regard to conflict of law provisions.&nbsp;</p></blockquote>
<!-- /wp:quote -->

<!-- wp:paragraph -->
<p><strong>Unsolicited Material.</strong></p>
<!-- /wp:paragraph -->

<!-- wp:quote -->
<blockquote class="wp-block-quote"><p>We always appreciate feedback or other suggestions, but may use them without any restrictions or obligation to compensate you for them, and are under no obligation to keep them confidential.&nbsp;</p></blockquote>
<!-- /wp:quote -->

<!-- wp:heading {"level":3} -->
<h3><strong>Updating These Terms</strong></h3>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>We may change our Service and policies, and we may need to make changes to these Terms so that they accurately reflect our Service and policies. Unless otherwise required by law, we will notify you (for example, through our Service) at least 30 days before we make changes to these Terms and give you an opportunity to review them before they go into effect. Then, if you continue to use the Service, you will be bound by the updated Terms. If you do not want to agree to these or any updated Terms, you can delete your account.</p>
<br>
<p>Revised: September 19, 2020</p>
<!-- /wp:paragraph -->



                """,
                padding: EdgeInsets.all(16.0),
                onLinkTap: (url) {
                  print("Opening $url...");
                },
                customRender: (node, children) {
                  if (node is dom.Element) {
                    switch (node.localName) {
                      case "custom_tag": // using this, you can handle custom tags in your HTML 
                        return Column(children: children);
                    }
                  }
                },
              ),


                  ],
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
            ),
          ),
        ],
      ),
    );
  }
}
