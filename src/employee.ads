with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Employee is
    type Employee is private;

    function create(name: String) return Employee;

    function getName(this: Employee) return String;

    private
        type Employee is record
            Name : Unbounded_String;
        end record;
end Employee;
