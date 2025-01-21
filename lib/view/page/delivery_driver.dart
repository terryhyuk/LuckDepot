import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucky_depot/view/widgets/coustom_drawer.dart';
import 'package:lucky_depot/view/widgets/coustom_text_form_field.dart';
import 'package:lucky_depot/vm/delivery_driver_controller.dart';

class DeliveryDriver extends StatefulWidget {
  const DeliveryDriver({super.key});

  @override
  State<DeliveryDriver> createState() => _DeliveryDriverState();
}

class _DeliveryDriverState extends State<DeliveryDriver> {
  final _controller = Get.put(DeliveryDriverController());

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
                  Expanded(
                    child: Row(
                      children: [
                        // 왼쪽 등록 폼
                        Expanded(
                          flex: 1,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: FocusTraversalGroup(
                                child: Form(
                                  key: _controller.formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'New Driver Registration',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      CustomTextFormField(
                                        controller: _controller.nameController,
                                        labelText: 'Name',
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context).nextFocus(),
                                      ),
                                      const SizedBox(height: 16),  // 간격 추가
                                      CustomTextFormField(
                                        controller: _controller.idController,
                                        labelText: 'ID',
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context).nextFocus(),
                                      ),
                                      const SizedBox(height: 16),  // 간격 추가
                                      CustomTextFormField(
                                        controller:
                                            _controller.passwordController,
                                        labelText: 'Password',
                                        isPassword: true,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context).nextFocus(),
                                      ),
                                      const SizedBox(height: 16),  // 간격 추가
                                      CustomTextFormField(
                                        controller: _controller.emailController,
                                        labelText: 'Email',
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context).nextFocus(),
                                      ),
                                      const SizedBox(height: 16),  // 간격 추가
                                      CustomTextFormField(
                                        controller: _controller.phoneController,
                                        labelText: 'Phone',
                                        isNumber: true,
                                        hintText: 'Numbers only',
                                        textInputAction: TextInputAction.done,
                                        onFieldSubmitted: (_) =>
                                            FocusScope.of(context).unfocus(),
                                      ),
                                      const SizedBox(height: 16),
                                      Obx(() => Row(
                                            children: [
                                              const Text(
                                                'Employment Type:',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Expanded(
                                                child: RadioListTile<bool>(
                                                  title: const Text('Full-time'),
                                                  value: true,
                                                  groupValue:
                                                      _controller.isRegular.value,
                                                  onChanged: (value) =>
                                                      _controller.isRegular
                                                          .value = value!,
                                                  activeColor: Colors.blue,
                                                  dense: true,
                                                ),
                                              ),
                                              Expanded(
                                                child: RadioListTile<bool>(
                                                  title: const Text('Part-time'),
                                                  value: false,
                                                  groupValue:
                                                      _controller.isRegular.value,
                                                  onChanged: (value) =>
                                                      _controller.isRegular
                                                          .value = value!,
                                                  activeColor: Colors.blue,
                                                  dense: true,
                                                ),
                                              ),
                                            ],
                                          )),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () =>
                                            _controller.saveDriver(context),
                                        style: ElevatedButton.styleFrom(
                                          minimumSize:
                                              const Size(double.infinity, 50),
                                        ),
                                        child: const Text('Register'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        // 오른쪽 목록
                        Expanded(
                          flex: 2,
                          child: Card(
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
                                      valueListenable:
                                          _controller.getDriverListenable(),
                                      builder: (context, box, _) {
                                        if (box.isEmpty) {
                                          return const Center(
                                            child:
                                                Text('No registered drivers'),
                                          );
                                        }
                                        return ListView.builder(
                                          itemCount: box.length,
                                          itemBuilder: (context, index) {
                                            final driver = box.getAt(index);
                                            return Card(
                                              child: ListTile(
                                                title: Text(driver!.name),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('ID: ${driver.id}'),
                                                    Text(
                                                        'Email: ${driver.email}'),
                                                    Text(
                                                        'Phone: ${driver.phone}'),
                                                  ],
                                                ),
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      driver.isRegular
                                                          ? 'Full-time'
                                                          : 'Part-time',
                                                      style: TextStyle(
                                                        color: driver.isRegular
                                                            ? Colors.blue
                                                            : Colors.grey,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.delete),
                                                      onPressed: () =>
                                                          _controller
                                                              .deleteDriver(
                                                                  context,
                                                                  index),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
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
        ],
      ),
    );
  }
}
