package body Engine_Pkg is
    function getMaxThrustVac(this : Engines) return Float is
    begin
        return this.max_thrust;
    end getMaxThrustVac;

    procedure setMaxThrustVac(this : in out Engines; thrust : Float) is
    begin
        this.max_thrust := thrust;
    end setMaxThrustVac;

    function getMinThrustVac(this : Engines) return Float is
    begin
        return this.min_thrust;
    end getMinThrustVac;

    procedure setMinThrustVac(this : in out Engines; thrust : Float) is
    begin
        this.min_thrust := thrust;
    end setMinThrustVac;

    function getAslIsp(this : Engines) return Float is
    begin
        return this.asl_isp;
    end getAslIsp;

    procedure setAslIsp(this : in out Engines; isp : Float) is
    begin
        this.asl_isp := isp;
    end setAslIsp;

    function getVacIsp(this : Engines) return Float is
    begin
        return this.vac_isp;
    end getVacIsp;

    procedure setVacIsp(this : in out Engines; isp : Float) is
    begin
        this.vac_isp := isp;
    end setVacIsp;


    function getMaxThrustAsl(this : Engines) return Float is
    begin
        return this.max_thrust * this.getAslIsp / this.getVacIsp;
    end getMaxThrustAsl;

    function getMinThrustAsl(this : Engines) return Float is
    begin
        return this.min_thrust * this.getAslIsp / this.getVacIsp;
    end getMinThrustAsl;

    function getMassFlowRate(this : Engines; throttle : Engine_Throttle) return Float is
    begin
        if throttle < this.getMinThrustVac / this.getMaxThrustVac then
            raise Minimum_Throttle_Exceeded;
        end if;
        return 9.80665 * this.getVacIsp * this.getMaxThrustVac * throttle;
    end getMassFlowRate;

end Engine_Pkg;
