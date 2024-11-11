import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forms_app/presentation/blocs/register/register_cubit.dart';
import 'package:forms_app/presentation/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Account'),
        ),
        body: BlocProvider(
          create: (context) => RegisterCubit(),
          child: const _RegisterView(),
        ));
  }
}

class _RegisterView extends StatelessWidget {
  const _RegisterView();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            FlutterLogo(
              size: 100,
            ),
            _RegisterForm(),
            SizedBox(
              height: 20,
            ),
          ]),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final registerCubit = context.watch<RegisterCubit>();
    return Form(
        key: _formkey,
        child: Column(
          children: [
            CustomTextFormField(
              label: 'User Name',
              onChanged: (value) {
                registerCubit.usernameChanged(value);
                _formkey.currentState?.validate();
              },
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required Field';
                if (value.trim().isEmpty) return 'Required Field';
                if (value.length <= 3) {
                  return 'The name must be at least 3 characters long';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              label: 'email',
              onChanged: (value) {
                registerCubit.emailChange(value);
                _formkey.currentState?.validate();
              },
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required Field';
                if (value.trim().isEmpty) return 'Required Field';
                final emailRegExp = RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                );
                if (!emailRegExp.hasMatch(value)) return 'Invalid Email';
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              label: 'Password',
              obscureText: true,
              onChanged: (value) {
                registerCubit.passwordChanged(value);
                _formkey.currentState?.validate();
              },
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required Field';
                if (value.trim().isEmpty) return 'Required Field';
                if (value.length <= 6) {
                  return 'The name must be at least 6 characters long';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            FilledButton.tonalIcon(
                onPressed: () {
                  final isValid = _formkey.currentState!.validate();
                  if (!isValid) return;

                  registerCubit.onSubmit();
                },
                label: const Text('Create User'),
                icon: const Icon(Icons.save)),
          ],
        ));
  }
}
