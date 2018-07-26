package body Engine_Pkg is
    function getMaxThrustVac(this : Engines) return Force is
    begin
        return this.max_thrust;
    end getMaxThrustVac;


    procedure setMaxThrustVac(this : in out Engines; thrust : Force) is
    begin
        this.max_thrust := thrust;
    end setMaxThrustVac;


    function getMinThrustVac(this : Engines) return Force is
    begin
        return this.min_thrust;
    end getMinThrustVac;


    procedure setMinThrustVac(this : in out Engines; thrust : Force) is
    begin
        this.min_thrust := thrust;
    end setMinThrustVac;


    function getAslIsp(this : Engines) return Time is
    begin
        return this.asl_isp;
    end getAslIsp;


    procedure setAslIsp(this : in out Engines; isp : Time) is
    begin
        this.asl_isp := isp;
    end setAslIsp;


    function getVacIsp(this : Engines) return Time is
    begin
        return this.vac_isp;
    end getVacIsp;


    procedure setVacIsp(this : in out Engines; isp : Time) is
    begin
        this.vac_isp := isp;
    end setVacIsp;


    function getThrustVac(this : Engines; throttle : Engine_Throttle := 1.0) return Force is
    begin
        if throttle < this.getMinThrustVac / this.getMaxThrustVac then
            raise Minimum_Throttle_Exceeded;
        end if;
        return this.getMaxThrustVac * throttle;
    end getThrustVac;


    function getMaxThrustAsl(this : Engines) return Force is
    begin
        return this.max_thrust * this.getAslIsp / this.getVacIsp;
    end getMaxThrustAsl;


    function getMinThrustAsl(this : Engines) return Force is
    begin
        return this.min_thrust * this.getAslIsp / this.getVacIsp;
    end getMinThrustAsl;


    function getThrustAsl(this : Engines; throttle : Engine_Throttle := 1.0) return Force is
    begin
        if throttle < this.getMinThrustAsl / this.getMaxThrustAsl then
            raise Minimum_Throttle_Exceeded;
        end if;
        return this.getMaxThrustAsl * throttle;
    end getThrustAsl;


    function getMassFlowRate(this : Engines; throttle : Engine_Throttle) return Mass_Flow is
    begin
        if throttle < this.getMinThrustVac / this.getMaxThrustVac then
            raise Minimum_Throttle_Exceeded;
        end if;
        return this.getMaxThrustVac * throttle / (gravity * this.getVacIsp);
    end getMassFlowRate;

end Engine_Pkg;
