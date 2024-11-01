import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  Future<void> _sendFeedback() async {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String feedback = _feedbackController.text;

    // SMTP server configuration
    String username = 'patareharsh@gmail.com';
    String password = '156546556456';
    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Harsh')
      ..recipients.add('patareharsh@gmail.com') // your email address
      ..subject = 'Feedback from $name'
      ..text = 'Name: $name\nEmail: $email\n\nFeedback:\n$feedback';

    try {
      await send(message, smtpServer);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback sent successfully!')),
      );
      _nameController.clear();
      _emailController.clear();
      _feedbackController.clear();
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send feedback')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black),
          onPressed: () {
              Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [

          ],
        ),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          SizedBox(
            width: 53.0,
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/new_box.png",height: 200.0),
                ],
              ),
              LabelValueRow(
               "Developer ","Harsh Patare",
               padding: EdgeInsets.only(left:80.0),
              ),

              LabelValueRow(
                "Email ","patareharsh@gmail.com",
                padding: EdgeInsets.only(left:80.0),
              ),

              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Your Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Your Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _feedbackController,
                decoration: InputDecoration(labelText: 'Feedback!!'),
                maxLines: 4,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendFeedback,
                child: Text('Submit Feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LabelValueRow extends StatelessWidget {
  LabelValueRow(this.label, this.value,
      {this.maxLines = false, this.padding, this.isExpanded = false,this.expandValue=3});

  final String label;
  final String value;
  final bool maxLines;
  final bool isExpanded;
  final int expandValue;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.all(0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isExpanded == true
              ? Text(
            "$label",
          )
              : Expanded(
            flex: 1,
            child: Text(
              "$label",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: 14.0
              ),
            ),
          ),
          Text(": ",
          ),
          Expanded(
            flex: expandValue,
            child: Text(
            "$value",style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0
            ),
            ),
          ),
        ],
      ),
    );
  }
}