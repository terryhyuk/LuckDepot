import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/model/coustom_text_form_field.dart';
import 'package:lucky_depot/view/widgets/coustom_drawer.dart';
import 'package:lucky_depot/view/widgets/coustom_text_form_field_widget.dart';
import 'package:lucky_depot/view/widgets/dialog.dart';
import 'package:lucky_depot/vm/delivery_driver_controller.dart';

class DeliveryDriver extends StatelessWidget {
  DeliveryDriver({super.key});

  final delivery = Get.find<DeliveryDriverController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          CustomDrawer(),
          Expanded(
            child: Container(
              color: Colors.grey[100],
            padding: const EdgeInsets.all(24),
            constraints: BoxConstraints( // 최소 높이 설정
              minHeight: MediaQuery.of(context).size.height,
            ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Delivery Driver Management',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Form(
                                  key: delivery.formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
                                        child: const Text(
                                          'New Driver Registration',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      // const SizedBox(height: 16),
                                      FocusTraversalGroup(
                                        policy: OrderedTraversalPolicy(),
                                        child: Column(
                                          children: [
                                            CustomTextFormFieldWidget(
                                              controller: delivery.nameController,
                                              config: TextFormFieldConfig(
                                                labelText: 'Name',
                                                textInputAction:
                                                    TextInputAction.next,
                                              ),
                                              focusNode: delivery.nameFocusNode,
                                              onFieldSubmitted: (_) =>
                                                  delivery.nextFocus(
                                                      delivery.nameFocusNode,
                                                      delivery.idFocusNode),
                                            ),
                                            const SizedBox(height: 16),
                                            CustomTextFormFieldWidget(
                                              controller: delivery.idController,
                                              config: TextFormFieldConfig(
                                                labelText: 'ID',
                                                textInputAction:
                                                    TextInputAction.next,
                                              ),
                                              focusNode: delivery.idFocusNode,
                                              onFieldSubmitted: (_) =>
                                                  delivery.nextFocus(
                                                      delivery.idFocusNode,
                                                      delivery.passwordFocusNode),
                                            ),
                                            const SizedBox(height: 16),
                                            CustomTextFormFieldWidget(
                                              controller:
                                                  delivery.passwordController,
                                              config: TextFormFieldConfig(
                                                labelText: 'Password',
                                                isPassword: true,
                                                textInputAction:
                                                    TextInputAction.next,
                                              ),
                                              focusNode:
                                                  delivery.passwordFocusNode,
                                              onFieldSubmitted: (_) =>
                                                  delivery.nextFocus(
                                                      delivery.passwordFocusNode,
                                                      delivery.emailFocusNode),
                                            ),
                                            const SizedBox(height: 16),
                                            CustomTextFormFieldWidget(
                                              controller:
                                                  delivery.emailController,
                                              config: TextFormFieldConfig(
                                                labelText: 'Email',
                                                textInputAction:
                                                    TextInputAction.next,
                                              ),
                                              focusNode: delivery.emailFocusNode,
                                              onFieldSubmitted: (_) =>
                                                  delivery.nextFocus(
                                                      delivery.emailFocusNode,
                                                      delivery.phoneFocusNode),
                                            ),
                                            const SizedBox(height: 16),
                                            CustomTextFormFieldWidget(
                                              controller:
                                                  delivery.phoneController,
                                              config: TextFormFieldConfig(
                                                labelText: 'Phone',
                                                isNumber: true,
                                                hintText: 'Numbers only',
                                                textInputAction:
                                                    TextInputAction.done,
                                              ),
                                              focusNode: delivery.phoneFocusNode,
                                              onFieldSubmitted: (_) =>
                                                  delivery.finishInput(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Obx(() => Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                        child: Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(0 ,MediaQuery.of(context).size.height * 0.01,0, MediaQuery.of(context).size.height * 0.01),
                                                  child: const Text(
                                                    'Employment Type',
                                                    style: TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: RadioListTile<bool>(
                                                        title: const Column(
                                                          children: [
                                                             Text('Full-Time'),
                                                          ],
                                                        ),
                                                        value: true,
                                                        groupValue:
                                                            delivery.isRegular.value,
                                                        onChanged: (value) => delivery
                                                            .isRegular.value = value!,
                                                        activeColor: Colors.blue,
                                                        dense: true,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: RadioListTile<bool>(
                                                        title: const Column(
                                                          children: [
                                                             Text('Part-Time'),
                                                          ],
                                                        ),
                                                        value: false,
                                                        groupValue:
                                                            delivery.isRegular.value,
                                                        onChanged: (value) => delivery
                                                            .isRegular.value = value!,
                                                        activeColor: Colors.blue,
                                                        dense: true,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                      )),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0,30,0,10),
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              delivery.saveDriver(context),
                                          style: ElevatedButton.styleFrom(
                                            minimumSize:
                                                const Size(double.infinity, 50),
                                                // backgroundColor: Colors.grey[200]
                                                backgroundColor: Colors.blue[50]
                                          ),
                                          child: const Text('Register'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
Expanded(
  flex: 2,
  child: Card(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Registered Drivers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: delivery.getDriverListenable(),
              builder: (context, box, _) {
                if (box.isEmpty) {
                  return const Center(
                    child: Text('No registered drivers'),
                  );
                }
                return SingleChildScrollView( 
                  child: Column(
                    children: List.generate(
                      box.length,
                      (index) {
                        final driver = box.getAt(index);
                        return Card(
                          color: Colors.grey[50],
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(driver!.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: ${driver.id}'),
                                Text('Email: ${driver.email}'),
                                Text('Phone: ${driver.phone}'),
                                Text(
                                  driver.isRegular ? 'Full-time' : 'Part-time',
                                  style: TextStyle(
                                    color: driver.isRegular ? Colors.blue : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => CustomDialog.show(
                                context,
                                DialogType.delete,
                                customContent: 'Are you sure you want to delete "${driver.name}"?',
                                onConfirm: () async {
                                  await delivery.deleteDriver(context, index);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  ),
),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}// END

