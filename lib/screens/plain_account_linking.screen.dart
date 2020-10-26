import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plaid_flutter/plaid_flutter.dart';

class PlaidAccountLinkingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlaidAccountLinkingScreenState();
  }
}

class _PlaidAccountLinkingScreenState extends State<PlaidAccountLinkingScreen> {
  PlaidLink _plaidPublicKey, _plaidLinkToken;

  @override
  void initState() {
    super.initState();

    LinkConfiguration publicKeyConfiguration = LinkConfiguration(
      clientName: "CLIENT_NAME",
      publicKey: "PUBLIC_KEY",
      env: LinkEnv.sandbox,
      products: <LinkProduct>[
        LinkProduct.auth,
      ],
      accountSubtypes: {
        "depository": ["checking", "savings"],
      },
      language: "en",
      countryCodes: ['US'],
      userLegalName: "John Appleseed",
      userEmailAddress: "jappleseed@youapp.com",
      userPhoneNumber: "+1 (512) 555-1234",
    );

    // Generate link token here
    // (Redacted for security reasons)
    // https://plaid.com/docs/api/tokens/#linktokencreate

    LinkConfiguration linkTokenConfiguration = LinkConfiguration(
      linkToken: "<ADD LINK_TOKEN HERE>",
    );

    _plaidPublicKey = PlaidLink(
      configuration: publicKeyConfiguration,
      onSuccess: _onSuccessCallback,
      onEvent: _onEventCallback,
      onExit: _onExitCallback,
    );

    _plaidLinkToken = PlaidLink(
      configuration: linkTokenConfiguration,
      onSuccess: _onSuccessCallback,
      onEvent: _onEventCallback,
      onExit: _onExitCallback,
    );
  }

  void _onSuccessCallback(String publicToken, LinkSuccessMetadata metadata) {
    print("onSuccess: $publicToken, metadata: ${metadata.description()}");
  }

  void _onEventCallback(String event, LinkEventMetadata metadata) {
    print("onEvent: $event, metadata: ${metadata.description()}");
  }

  void _onExitCallback(String error, LinkExitMetadata metadata) {
    print("onExit: $error, metadata: ${metadata.description()}");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Test Plaid Integration"),
              RaisedButton(
                onPressed: () => _plaidLinkToken.open(),
                child: Text("Open Plaid Link (Link Token)"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
