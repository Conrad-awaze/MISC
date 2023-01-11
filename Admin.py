from Doctor import Doctor


class Admin:
    """A class that deals with the Admin operations"""
    def __init__(self, username, password, address = ''):
        """
        Args:
            username (string): Username
            password (string): Password
            address (string, optional): Address Defaults to ''
        """

        self.__username = username
        self.__password = password
        self.__address =  address

    def view(self,a_list):
        """
        print a list
        Args:
            a_list (list): a list of printables
        """
        for index, item in enumerate(a_list):
            print(f'{index+1:3} | {item}')

    def login(self) :
        """
        A method that deals with the login
        Raises:
            Exception: returned when the username and the password ...
                    ... don`t match the data registered
        Returns:
            string: the username
        """
    
        print("-----Login-----")
        #Get the details of the admin

        username = input('Enter the username: ')
        password = input('Enter the password: ')
        return self.__username in username and self.__password == password
        

    def find_index(self,index,doctors):
        
            # check that the doctor id exists          
        if index in range(0,len(doctors)):
            
            return True

        # if the id is not in the list of doctors
        else:
            return False
    
    def find_index_patient(self,index,patients):
        
            # check that the patient id exists          
        if index in range(0,len(patients)):
            
            return True

        # if the id is not in the list of patients
        else:
            return False
            
    def get_doctor_details(self) :
        """
        Get the details needed to add a doctor
        Returns:
            first name, surname and ...
     ... the speciality of the doctor in that order.
        """
        first_name = input("Enter First Name: ")
        surname = input("Enter Surname: ")
        speciality = input("Enter Speciality:")
        return first_name,surname,speciality
        

    def doctor_management(self, doctors):
        """
        A method that deals with registering, viewing, updating, deleting doctors
        Args:
            doctors (list<doctor>): the list of all the doctors names
        """

        print("-----doctor Management-----")

        # menu
        print('Choose the operation:')
        print(' 1 - Register')
        print(' 2 - View')
        print(' 3 - Update')
        print(' 4 - Delete')

        op=input("Operation: ")
        


        # register
        if op == '1':
            print("-----Register-----")

            # get the doctor details
            print('Enter the doctor\'s details:')
            first_name, surname, speciality = self.get_doctor_details()
            name_exists=False

            # check if the name is already registered
            for doctor in doctors:
                if first_name == doctor.get_first_name() and surname == doctor.get_surname():
                    name_exists =True
                    print('Name already exists.')
                    break
                
            if name_exists==False:
                    doctors.append(Doctor(first_name, surname,speciality ))
                    print('doctor registered.')
            
                                                             # ... to the list of doctors
               

        # View
        elif op == '2':
            print("-----List of doctors-----")
            print('ID |          Full name           |  Speciality')
            Admin.view(self, doctors)
            

        # Update
        elif op == '3':
            while True:
                print("-----Update doctor`s Details-----")
                print('ID |          Full name           |  Speciality')
                Admin.view(self, doctors)
                try:
                    index = int(input('Enter the ID of the doctor: ')) - 1
                    doctor_index=self.find_index(index,doctors)
                    if doctor_index!=False:
                        
                        print('Choose the field to be updated:')
                        print(' 1 first name')
                        print(' 2 surname')
                        print(' 3 speciality')
                        op = int(input('Input: ')) # make the user input lowercase
                        if op==1:
                            first_name = input("Enter Updated First Name: ")
                            doctors[index].set_first_name(first_name)
                            print("first name has been updated")
                            
                        elif op==2:
                             surname = input("Enter the new surname: ")
                             doctors[index].set_surname(surname)
                             print("surname has been updated")
                                
                        elif op==3:
                            speciality= input("Enter Updated speciality: ")
                            doctors[index].set_speciality(speciality)
                            print("speciality has been updated")
                            
                        else:
                            print('Invalid operation choosen.')
                        
                
                        break
                        
                    else:
                        print("Doctor not found")

                    
                        # doctor_index is the ID mines one (-1)
                        

                except ValueError: # the entered id could not be changed into an int
                    print('The ID entered is incorrect')
    
                
                

        # Delete
        elif op == '4':
            while True:
                print("-----Delete doctor-----")
                print('ID |          Full Name           |  Speciality')
                Admin.view(self, doctors)
                try:     
                    index = int(input('Enter the ID of the doctor to be deleted: ')) -1
                    delete=index+1
                    delete_index=self.find_index(index,doctors)
                    if delete_index!=False:
                        doctors.pop(delete-1)
                        print("Contact has been deleted, These are the remaining doctors: ")
                        Admin.view(self, doctors)
                        break
                    else:
                        print('The ID entered is incorrect')
                        break
                    
                except ValueError: # the entered id could not be changed into an int
                    print('The ID entered is incorrect')
            #ToDo9
            


        # if the id is not in the list of patients
        else:
            print('Invalid operation choosen. Check your spelling!')


    def view_patient(self, patients):
        """
        print a list of patients
        Args:
            patients (list<Patients>): list of all the active patients
        """
        print("-----View Patients-----")
        print('ID |          Full Name           |      doctor`s Full Name      | Age |    Mobile     | Postcode ')
        self.view(patients)
        #ToDo10
        

    def assign_doctor_to_patient(self, patients, doctors):
        """
        Allow the admin to assign a doctor to a patient
        Args:
            patients (list<Patients>): the list of all the active patients
            doctors (list<doctor>): the list of all the doctors
        """
        print("-----Assign-----")

        print("-----Patients-----")
        print('ID |          Full Name           |      doctor`s Full Name      | Age |    Mobile     | Postcode ')
        Admin.view(self, patients)

        patient_index = input('Please enter the patient ID: ')

        try:
            # patient_index is the patient ID mines one (-1)
            patient_index = int(patient_index) -1

            # check if the id is not in the list of patients
            if patient_index not in range(len(patients)):
                print('The id entered was not found.')
                return # stop the procedures

        except ValueError: # the entered id could not be changed into an int
            print('The id entered is incorrect')
            return # stop the procedures

        print("-----doctors Select-----")
        print('Select the doctor that fits these symptoms:')
        patients[patient_index].print_symptoms() # print the patient symptoms

        print('--------------------------------------------------')
        print('ID |          Full Name           |  Speciality   ')
        Admin.view(self, doctors)
        doctor_index = input('Please enter the doctor ID: ')

        try:
            # doctor_index is the patient ID mines one (-1)
            doctor_index = int(doctor_index) -1

            # check if the id is in the list of doctors
            if self.find_index(doctor_index,doctors)!=False:
                    
                doctors[doctor_index].add_patient(patients[patient_index])
                patients[patient_index].link(doctors[doctor_index])
                
                
                print('The patient is now assign to the doctor.')
                

            # if the id is not in the list of doctors
            else:
                print('The id entered was not found.')

        except ValueError: # the entered id could not be changed into an in
            print('The id entered is incorrect')

    def patient_discharge(self, patients, discharged_patients):
        try: 
            index = int(input('Please enter the patient ID: ')) -1
            delete=index+1
            delete_index=self.find_index_patient(index,patients)
            if delete_index!=False:
                discharged_patients.append(patients.pop(delete-1))
                print("patient has been discharged, These are the remaining patients")
                Admin.view(self, patients)
            if delete_index==False:
                print("'The id entered was not found.'")
        except ValueError: # the entered id could not be changed into an int
            print('The id entered is incorrect')
        
    def discharge(self, patients, discharged_patients):
        """
        Allow the admin to discharge a patient when treatment is done
        Args:
            patients (list<Patients>): the list of all the active patients
            discharge_patients (list<Patients>): the list of all the non-active patients
        """
    
        print("--------Discharge Patient--------")
        print("    ----Patients----    ")
        Admin.view(self, patients)
        
            
        #ToDo12
        

    def view_discharge(self, discharged_patients):
        """
        Prints the list of all discharged patients
        Args:
            discharge_patients (list<Patients>): the list of all the non-active patients
        """

        print("-----Discharged Patients-----")
        print('ID |          Full Name           |      doctor`s Full Name      | Age |    Mobile     | Postcode ')
        Admin.view(self, discharged_patients)
        #ToDo13
        

    def update_details(self):
        """
        Allows the user to update and change username, password and address
        """


        print('Choose the field to be updated:')
        print(' 1 Username')
        print(' 2 Password')
        print(' 3 Address')
        op = int(input('Input: '))

        if op == 1:
            print("current username is", self.__username)
            self.__username = str(input('Enter the new username: '))
            
            
            print("Username has been updated, New username is", self.__username)
            #ToDo14
            

        elif op == 2:
            print("current password is", self.__password)
            self.__password = str(input('Enter the new password: '))
            # validate the password
            if self.__password == input('Enter the new password again: '):
                print("Password has been updated")
                print("Password has been updated, new password is", self.__password)

        elif op == 3:
            print("current address is ", self.__address)
            self.__address = str(input('Enter the new address: '))
            print("Address has been updated, new address is ", self.__address)
            
            

        else:
            print('Invalid choice. Please try again!')
            
            
            

