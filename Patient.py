class Patient:
    """Patient class"""

    def __init__(self, first_name, surname, age, mobile, postcode):
       self.__forename = first_name
       self.__surname = surname
       self.__age = age
       self.__mobile = mobile
       self.__postcode = postcode
       self.__symptoms=[]
       self.__doctor = 'None'
       

    
    def full_name(self) :
        return f'{self.__forename} {self.__surname}'
        

    def get_doctor(self) :
        return self.__doctor

    def link(self, doctor):
        """Args: doctor(string): the doctor full name"""
        self.__doctor = doctor.full_name
       
        

    def print_symptoms(self):
        print (self.__symptoms)

    def __str__(self):
        return f'{self.full_name():^30}|{self.__doctor:^30}|{self.__age:^5}|{self.__mobile:^15}|{self.__postcode:^10}'
