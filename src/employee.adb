package body Employee is
    function create(name : String) return Employee is
        this : Employee;
    begin
        this.name := To_Unbounded_String(name);
        return this;
    end create;

    function getName(this : Employee) return String is
    begin
        return To_String(this.name);
    end getName;
end Employee;
