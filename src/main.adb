-- Main
with Text_IO; use Text_IO;
with Employee;

procedure Main is
    sample_employee : Employee.Employee;
begin
    sample_employee := Employee.create("John Doe");
    Put_line(Employee.getName(sample_employee));
end Main;
