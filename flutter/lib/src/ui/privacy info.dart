import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;


class Privacy extends StatefulWidget {
  @override
  StoryTellerSettings createState() => new StoryTellerSettings();
}

class StoryTellerSettings extends State<Privacy> {
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
                  'Privacy Policy',
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
 
<!-- wp:paragraph -->
<p>This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at Teling unless otherwise defined in this Privacy Policy.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p><strong><span class="uppercase">Information Collection and Use</span></strong></p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>For a better experience, while using our Service, I may require you to provide us with certain personally identifiable information. The information that I request will be retained on your device and is not collected by me in any way.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>The app does use third party services that may collect information used to identify you.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>Link to privacy policy of third party service providers used by the app</p>
<!-- /wp:paragraph -->

<!-- wp:list -->
<ul><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noreferrer noopener">AdMob</a></li><li><a href="https://onesignal.com/privacy_policy" target="_blank" rel="noreferrer noopener">One Signal</a></li></ul>
<!-- /wp:list -->

<!-- wp:paragraph -->
<p><strong><span class="uppercase">Log Data</span></strong></p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>I want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p><strong><span class="uppercase">Cookies</span></strong></p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>This Service does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p><strong><span class="uppercase">Service Providers</span></strong></p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>I may employ third-party companies and individuals due to the following reasons:</p>
<!-- /wp:paragraph -->

<!-- wp:list -->
<ul><li>To facilitate our Service;</li><li>To provide the Service on our behalf;</li><li>To perform Service-related services; or</li><li>To assist us in analyzing how our Service is used.</li></ul>
<!-- /wp:list -->

<!-- wp:paragraph -->
<p>I want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p><strong><span class="uppercase">Security</span></strong></p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>I value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p><strong><span class="uppercase">Links to Other Sites</span></strong></p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p><strong><span class="uppercase">Children’s Privacy</span></strong></p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>These Services do not address anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13. In the case I discover that a child under 13 has provided me with personal information, I immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that I will be able to do necessary actions.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p><strong><span class="uppercase">Changes to This Privacy Policy</span></strong></p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>I may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>This policy is effective as of 2020-09-05</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p><strong><span class="uppercase">Contact Us</span></strong></p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at support@teling.app.</p>
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
