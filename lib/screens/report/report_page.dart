import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:open_mail_app/open_mail_app.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController contentController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo[50],
        appBar: AppBar(
          title: Text("reportProblem".tr),
        ),
        body: AutofillGroup(
            child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text("${"title".tr}:",
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                      TextFormField(
                          keyboardType: TextInputType.text,
                          controller: titleController,
                          autofillHints: const [AutofillHints.name],
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            labelText: '${"enter".tr} ${"title".tr}',
                            filled: true,
                          ),
                          onTapOutside: (event) =>
                              FocusScope.of(context).unfocus(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'fieldNull'.tr;
                            }
                            return null;
                          }),
                      const SizedBox(height: 20),
                      Text("${"content".tr}:",
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                      TextFormField(
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          controller: contentController,
                          autofillHints: const [AutofillHints.name],
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            labelText: '${"enter".tr} ${"content".tr}',
                            alignLabelWithHint: true,
                            filled: true,
                          ),
                          onTapOutside: (event) =>
                              FocusScope.of(context).unfocus(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'fieldNull'.tr;
                            }
                            return null;
                          }),
                      const SizedBox(height: 50),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent.shade400,
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                EmailContent email = EmailContent(
                                  to: [
                                    'loc.phanthanh2011@gmail.com',
                                  ],
                                  subject: titleController.text,
                                  body: contentController.text,
                                );

                                OpenMailAppResult result =
                                    await OpenMailApp.composeNewEmailInMailApp(
                                        nativePickerTitle:
                                            'Select email app to compose',
                                        emailContent: email);

                                if (result.didOpen) {
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                }
                              }
                            },
                            child: Text(
                              "submit".tr,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      // const SizedBox(height: 50),
                    ]))));
  }
}
