



// ignore_for_file: dangling_library_doc_comments

/** add user center image and all the textline 
 * SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 74, left: 16, right: 16),
            child: Form(
              key: _formKey,
              child: Container(
                width: 350,
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 80,
                          width: 350,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xffffa89e), Color(0xffFCB4B0)],
                              stops: [0, 1],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -50,
                          left: 107,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 118,
                              height: 118,
                              decoration: BoxDecoration(
                                color: const Color(0xffffa89e),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xffFCB4B0),
                                  width: 4,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 60,
                                foregroundImage: studentProfile != null
                                    ? FileImage(studentProfile!)
                                    : const NetworkImage(
                                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                      ),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: TextFormField(
                        style: myTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffffa89e),
                        ),
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: "Username",
                          labelStyle: myTextStyle(
                            color: const Color(0xffffa89e),
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xffffa89e),
                              width: 2,
                            ),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xffffa89e),
                              width: 2,
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        focusNode: usernameFocusNode,
                        onFieldSubmitted: (value) {
                          usernameFocusNode.unfocus();
                          FocusScope.of(context)
                              .requestFocus(mobileNumberFocusNode);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: TextFormField(
                        style: myTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffffa89e),
                        ),
                        controller: mobileNumberController,
                        decoration: InputDecoration(
                          labelText: "Mobile Number",
                          labelStyle: myTextStyle(
                            color: const Color(0xffffa89e),
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xffffa89e),
                              width: 2,
                            ),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xffffa89e),
                              width: 2,
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        focusNode: mobileNumberFocusNode,
                        onFieldSubmitted: (value) {
                          mobileNumberFocusNode.unfocus();
                          FocusScope.of(context).requestFocus(codeFocusNode);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Consumer<DropdownProvider>(
                        builder: (context, dropdownProvider, _) {
                          return SizedBox(
                            height: 55,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              iconEnabledColor: const Color(0xffffa89e),
                              iconDisabledColor: const Color(0xffffa89e),
                              decoration: InputDecoration(
                                labelText: "Gender",
                                labelStyle: myTextStyle(
                                  color: const Color(0xffffa89e),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffffa89e),
                                    width: 2,
                                  ),
                                ),
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffffa89e),
                                    width: 2,
                                  ),
                                ),
                              ),
                              value: "Male",
                              onChanged: (String? newValue) {
                                context.read<StudentProvider>().getCode(
                                      context,
                                      studentGender: newValue!,
                                    );
                                dropdownProvider.setGender(newValue, context);
                              },
                              items: [
                                'Male',
                                'Female'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: myTextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xffffa89e),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ),
                    Consumer<StudentProvider>(
                      builder: (context, studentProvider, _) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: TextFormField(
                            style: myTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xffffa89e),
                            ),
                            readOnly: true,
                            controller: TextEditingController(
                                text: studentProvider.code),
                            decoration: InputDecoration(
                              labelText: "Code",
                              labelStyle: myTextStyle(
                                color: const Color(0xffffa89e),
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffffa89e),
                                  width: 2,
                                ),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffffa89e),
                                  width: 2,
                                ),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            focusNode: codeFocusNode,
                            onFieldSubmitted: (value) {
                              codeFocusNode.unfocus();
                            },
                            textInputAction: TextInputAction.done,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: context.watch<StudentProvider>().isLoading
                          ? const Center(
                              child: SizedBox(
                                child: CircularProgressIndicator(
                                  color: Color(0xffffa89e),
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _submitForm(currentYear, locationId!);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xffffa89e),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    child: Text('Submit',
                                        style: myTextStyle(
                                          color: AppColor.whiteColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Clear All Fields
                                      usernameController.clear();
                                      mobileNumberController.clear();
                                      studentProfile = null;
                                      setState(() {
                                        selectedGender = 'Male';
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    child: Text(
                                      'Clear',
                                      style: myTextStyle(
                                        color: AppColor.whiteColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
 */
/* add user details */

/*
  Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                studentProfile == null
                    ? GestureDetector(
                        onTap: () {
                          _pickImage();
                        },
                        child: DottedBorder(
                          strokeWidth: 2,
                          color: const Color(0xff5F259E),
                          dashPattern: const [10, 4],
                          radius: const Radius.circular(10),
                          borderType: BorderType.RRect,
                          strokeCap: StrokeCap.round,
                          child: SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.folder_open,
                                  size: 50,
                                  color: Color(0xff5F259E),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Select your image',
                                  style: myTextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff5F259E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _pickImage();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            studentProfile!,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                AuthField(
                  hintText: 'Name',
                  controller: nameController,
                  focusNode: nameFocusNode,
                  textInputType: TextInputType.name,
                  nextFocus: numberFocusNode,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: AuthField(
                        hintText: 'Mobile No.',
                        controller: numberController,
                        focusNode: numberFocusNode,
                        textInputType: TextInputType.phone,
                        nextFocus: monthFocusNode,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio<Gender>(
                            activeColor: const Color(0xff5F259E),
                            value: Gender.male,
                            groupValue: genderProvider.selectedGender,
                            onChanged: (Gender? value) {
                              if (value != null) {
                                genderProvider.setGender(value);
                              }
                            },
                          ),
                          const Icon(Icons.boy, color: Color(0xff5F259E)),
                          Radio<Gender>(
                            activeColor: const Color(0xff5F259E),
                            value: Gender.female,
                            groupValue: genderProvider.selectedGender,
                            onChanged: (Gender? value) {
                              if (value != null) {
                                genderProvider.setGender(value);
                              }
                            },
                          ),
                          const Icon(Icons.girl, color: Color(0xff5F259E)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: AuthField(
                        hintText: '0',
                        controller: monthController,
                        focusNode: monthFocusNode,
                        textInputType: TextInputType.number,
                        nextFocus: codeFocusNode,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio<PaymentType>(
                            activeColor: const Color(0xff5F259E),
                            value: PaymentType.monthly,
                            groupValue: paymentTypeProvider.selectedPaymentType,
                            onChanged: (PaymentType? value) {
                              if (value != null) {
                                paymentTypeProvider.setPaymentType(value);
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Y",
                              style: myTextStyle(
                                color: const Color(0xff5F259E),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // const SizedBox(width: 10),
                          Radio<PaymentType>(
                            activeColor: const Color(0xff5F259E),
                            value: PaymentType.yearly,
                            groupValue: paymentTypeProvider.selectedPaymentType,
                            onChanged: (PaymentType? value) {
                              if (value != null) {
                                paymentTypeProvider.setPaymentType(value);
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "M",
                              style: myTextStyle(
                                color: const Color(0xff5F259E),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio<PaymentMethod>(
                            activeColor: const Color(0xff5F259E),
                            value: PaymentMethod.cash,
                            groupValue:
                                paymentMethodProvider.selectedPaymentMethod,
                            onChanged: (PaymentMethod? value) {
                              if (value != null) {
                                paymentMethodProvider.setPaymentMethod(value);
                              }
                            },
                          ),
                          const SvgImage(
                            url: "assets/svg/caseNote.svg",
                            height: 25,
                          ),
                          const SizedBox(width: 10),
                          Radio<PaymentMethod>(
                            activeColor: const Color(0xff5F259E),
                            value: PaymentMethod.online,
                            groupValue:
                                paymentMethodProvider.selectedPaymentMethod,
                            onChanged: (PaymentMethod? value) {
                              if (value != null) {
                                paymentMethodProvider.setPaymentMethod(value);
                              }
                            },
                          ),
                          const SvgImage(
                              url: "assets/svg/online-pay.svg", height: 20),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      flex: 4,
                      child: AuthField(
                        hintText: 'E690000000',
                        controller: codeController,
                        focusNode: codeFocusNode,
                        textInputType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // update button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.445,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff5F259E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: () {
                          // Handle the payment button click

                          if (_formKey.currentState!.validate()) {
                            final student = Student(
                              studentName: nameController.text,
                              studentMobile: numberController.text,
                              studentGender: genderProvider.selectedGender ==
                                      Gender.male
                                  ? "Male"
                                  : "Female", // Example gender, replace with actual value
                              studentCode: codeController.text,
                              studentSession: currentYear.toString(),
                              studentLocation: locationName.toString(),
                              studentProfile: studentProfile!,
                            );

                            studentProvider.insertStudent(student, context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Student added successfully",
                                  style: myTextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.whiteColor,
                                  ),
                                ),
                                backgroundColor: const Color(0xff5F259E),
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(10),
                              ),
                            );
                            nameController.clear();
                            numberController.clear();
                            codeController.clear();
                            monthController.clear();

                            paymentTypeProvider
                                .setPaymentType(PaymentType.monthly);

                            paymentMethodProvider
                                .setPaymentMethod(PaymentMethod.cash);
                            genderProvider.setGender(Gender.male);
                            studentProfile = null;
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "Submit",
                          style: myTextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColor.whiteColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.445,
                      height: 40,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xff5F259E),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: () {
                          // reset the form
                          nameController.clear();
                          numberController.clear();
                          codeController.clear();
                          monthController.clear();
                          studentProfile = null;

                          paymentTypeProvider
                              .setPaymentType(PaymentType.monthly);

                          paymentMethodProvider
                              .setPaymentMethod(PaymentMethod.cash);
                          genderProvider.setGender(Gender.male);
                        },
                        child: Text(
                          "Clear",
                          style: myTextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff5F259E),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
 */

/* user details */
/*
  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xff5F259E),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Center(
                  child: Text(
                    'Customer Details',
                    style: myTextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'sans-serif-medium',
                    ),
                  ),
                ),
              ),

              // circle avatar
              CircleAvatar(
                backgroundImage: NetworkImage(widget.data.imageUrl),
                radius: 50,
              ),

              const SizedBox(height: 20),
              // name, mobile number, code, gender display

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Name",
                          style: myTextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'sans-serif-medium',
                          ),
                        ),
                        Text(
                          widget.data.name,
                          style: cost TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'sans-serif-medium',
                          ),
                        ),
                      ],
                    ),
                    // mobile
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Mobile",
                          style: myTextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'sans-serif-medium',
                          ),
                        ),
                        Text(
                          widget.data.number,
                          style: myTextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'sans-serif-medium',
                          ),
                        ),
                      ],
                    ),
                    // gender
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Gender",
                          style: myTextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'sans-serif-medium',
                          ),
                        ),
                        Text(
                          widget.data.code.substring(0, 4) == "MALE"
                              ? "Male"
                              : "Female",
                          style: myTextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'sans-serif-medium',
                          ),
                        ),
                      ],
                    ),
                    // code
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Code",
                          style: myTextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'sans-serif-medium',
                          ),
                        ),
                        Text(
                          widget.data.code,
                          style: myTextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'sans-serif-medium',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // update button
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {},
                  child: const Text("Update Profile"),
                ),
              ),
              const SizedBox(height: 10),

              // payment amount text field
              AuthField(
                  hintText: "Payment Amount",
                  controller: amountController,
                  prefixIcon: const Icon(Icons.attach_money),
                  focusNode: amountFocus,
                  textInputType: TextInputType.number),
              const SizedBox(height: 10),

              // payment status

              // two radio buttons for new and renew payment
              Consumer<PaymentProvider>(
                builder: (context, paymentProvider, child) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<PaymentStatus>(
                              activeColor: Colors.black,
                              title: const Text('New Payment'),
                              value: PaymentStatus.newPayment,
                              groupValue: paymentProvider.paymentStatus,
                              onChanged: (PaymentStatus? value) {
                                paymentProvider.setPaymentStatus(value!);
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<PaymentStatus>(
                              activeColor: Colors.black,
                              title: const Text('Renew Payment'),
                              value: PaymentStatus.renewPayment,
                              groupValue: paymentProvider.paymentStatus,
                              onChanged: (PaymentStatus? value) {
                                paymentProvider.setPaymentStatus(value!);
                              },
                            ),
                          ),
                        ],
                      ),

                      // Two radio buttons for monthly and yearly payments

                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<PaymentType>(
                              activeColor: Colors.black,
                              title: const Text('Monthly'),
                              value: PaymentType.monthly,
                              groupValue: paymentProvider.paymentType,
                              onChanged: (PaymentType? value) {
                                paymentProvider.setPaymentType(value!);
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<PaymentType>(
                              activeColor: Colors.black,
                              title: const Text('Yearly'),
                              value: PaymentType.yearly,
                              groupValue: paymentProvider.paymentType,
                              onChanged: (PaymentType? value) {
                                paymentProvider.setPaymentType(value!);
                              },
                            ),
                          ),
                        ],
                      ),

                      // Two radio buttons for payment methods: cash and online

                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<PaymentMethod>(
                              activeColor: Colors.black,
                              title: const Text('Cash'),
                              value: PaymentMethod.cash,
                              groupValue: paymentProvider.paymentMethod,
                              onChanged: (PaymentMethod? value) {
                                paymentProvider.setPaymentMethod(value!);
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<PaymentMethod>(
                              activeColor: Colors.black,
                              title: const Text('Online'),
                              value: PaymentMethod.online,
                              groupValue: paymentProvider.paymentMethod,
                              onChanged: (PaymentMethod? value) {
                                paymentProvider.setPaymentMethod(value!);
                              },
                            ),
                          ),
                        ],
                      ),

                      // payment button

                      ElevatedButton(
                        onPressed: () {
                          // Handle the payment button click
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.btnColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          textstyle: myTextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        child: const Text(
                          'Submit Payment',
                          style: myTextStyle(color: AppColor.greyColor),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
 */

/* Home Page */


// const Duration animationDuration = Duration(milliseconds: 1000);
//     final double height = MediaQuery.of(context).size.height;
//     final double width = MediaQuery.of(context).size.width;
//     final List<String> imgList = [
//       'https://i.pinimg.com/originals/8e/67/bb/8e67bb65cf6620375f8605b1467a848e.jpg',
//       'https://img.myloview.com/posters/vector-design-of-indian-couple-playing-garba-in-dandiya-night-in-disco-poster-for-navratri-dussehra-festival-of-india-invitation-card-background-700-228635592.jpg',
//       'https://www.shutterstock.com/image-vector/illustration-garba-festival-couple-dancing-260nw-1499772359.jpg',
//     ];
//     return Scaffold(
//       drawer: const Drawer(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             CupertinoPageRoute(
//               builder: (context) => const AddUserDetails(),
//               fullscreenDialog: true,
//             ),
//           );
//         },
//         backgroundColor: const Color(0xff5F259E),
//         child: const Icon(
//           Icons.add,
//           color: AppColor.blackColor,
//         ),
//       ),
//       appBar: AppBar(
//         title: Text(
//           'Dev Dandiya',
//           style: myTextStyle(
//             color: AppColor.blackColor,
//             fontWeight: FontWeight.w600,
//             fontSize: 25,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color(0xff5F259E),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16.0),
//             child: Center(
//               child: Text(
//                 '${DateTime.now().year}',
//                 style: myTextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: AppColor.blackColor,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Animated greeting and user name
//             Container(
//               height: 180,
//               width: double.infinity,
//               color: const Color(0xff5F259E),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // Animated greeting and user name
//                     Padding(
//                       padding: const EdgeInsets.only(left: 8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           FadeInDown(
//                             child: Text(
//                               'Hello',
//                               style: myTextStyle(
//                                 color: AppColor.blackColor,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           FadeInUp(
//                             child: Text(
//                               'Vikesh Bhuva',
//                               style: myTextStyle(
//                                 color: AppColor.blackColor,
//                                 fontSize: 30,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Animated SVG image
//                     FadeInUp(
//                       child: Image.asset(
//                         ImageUrl.garbaLogo,
//                         height: width * 0.38,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // setting box
//             Container(
//               height: height * 0.21,
//               color: const Color(0xff5F259E),
//               width: width,
//               padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       // male box
//                       FadeInLeft(
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: AppColor.whiteColor,
//                           ),
//                           height: height * 0.20,
//                           width: width * 0.44,
//                           padding: const EdgeInsets.all(8),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Row(
//                                 children: [
//                                   Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         "10",
//                                         style: myTextStyle(
//                                           color: AppColor.blackColor,
//                                           fontSize: 35,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Text(
//                                         "Male",
//                                         style: myTextStyle(
//                                           color: AppColor.blackColor,
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(
//                                     width: 20,
//                                   ),
//                                   SvgImage(
//                                     url: ImageUrl.male,
//                                     height: height * 0.09,
//                                   ),
//                                 ],
//                               ),
//                               const Divider(),
//                               GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           const HomeMalePage(),
//                                     ),
//                                   );
//                                 },
//                                 child: Row(
//                                   children: [
//                                     Text(
//                                       'View Details',
//                                       style: myTextStyle(
//                                         color: AppColor.blackColor,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       width: 20,
//                                     ),
//                                     const Icon(
//                                       Icons.arrow_forward_ios_rounded,
//                                       color: AppColor.blackColor,
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       // female box
//                       FadeInRight(
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: AppColor.whiteColor,
//                           ),
//                           height: height * 0.20,
//                           width: width * 0.44,
//                           padding: const EdgeInsets.all(8),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Row(
//                                 children: [
//                                   Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         "10",
//                                         style: myTextStyle(
//                                           color: AppColor.blackColor,
//                                           fontSize: 35,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Text(
//                                         "Female",
//                                         style: myTextStyle(
//                                           color: AppColor.blackColor,
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(
//                                     width: 8,
//                                   ),
//                                   SvgImage(
//                                     url: ImageUrl.female,
//                                     height: height * 0.09,
//                                   ),
//                                 ],
//                               ),
//                               const Divider(),
//                               GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           const HomeFemalePage(),
//                                     ),
//                                   );
//                                 },
//                                 child: Row(
//                                   children: [
//                                     Text(
//                                       'View Details',
//                                       style: myTextStyle(
//                                         color: AppColor.blackColor,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       width: 20,
//                                     ),
//                                     const Icon(
//                                       Icons.arrow_forward_ios_rounded,
//                                       color: AppColor.blackColor,
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             // Events

//             FadeInRight(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
//                 child: Container(
//                   width: width,
//                   padding: const EdgeInsets.only(
//                       left: 12, right: 0, top: 8, bottom: 8),
//                   decoration: const BoxDecoration(
//                     color: Color(0xff26D7FE),
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(10),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       // text :- if you want to add any event you can add here
//                       FadeInLeft(
//                         child: Text(
//                           "To add any \nevent click \non the image",
//                           style: myTextStyle(
//                             color: AppColor.blackColor,
//                             fontSize: 26,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: width * 0.016,
//                       ),
//                       FadeInRight(
//                         child: Image.asset(
//                           ImageUrl.eventlogo,
//                           height: height * 0.17,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             FadeInLeft(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
//                 child: Container(
//                   width: width,
//                   padding: const EdgeInsets.all(8),
//                   decoration: const BoxDecoration(
//                     color: Color(0xff26D7FE),
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(10),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       FadeInLeft(
//                         child: Image.asset(
//                           ImageUrl.reportlogo,
//                           height: height * 0.17,
//                         ),
//                       ),
//                       SizedBox(
//                         height: height * 0.01,
//                       ),
//                       // text :- if you want to add any event you can add here
//                       FadeInRight(
//                         child: Text(
//                           "To View \nReport click \non the image",
//                           style: myTextStyle(
//                             color: AppColor.blackColor,
//                             fontSize: 26,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );