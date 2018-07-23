with Ada.Numerics.Generic_Elementary_Functions;

package body Propulsion_Unit_Pkg is
    procedure addTank(this : in out Propulsion_Units; to_add : Tanks) is
    begin
        this.tankage.append(to_add);
    end addTank;


    function getNumTanks(this : Propulsion_Units) return Natural is
    begin
        return Natural(this.tankage.length);
    end getNumTanks;


    function getTank(this : Propulsion_Units; index : Natural) return Tanks is
    begin
        return this.tankage.element(index);
    end getTank;


    procedure removeTank(this : in out Propulsion_Units; index : Natural) is
    begin
        this.tankage.delete(index);
    end removeTank;


    procedure addEngine(this : in out Propulsion_Units; to_add : Engines) is
    begin
        this.engine_cluster.append(to_add);
    end addEngine;


    function getNumEngines(this : Propulsion_Units) return Natural is
    begin
        return Natural(this.engine_cluster.length);
    end getNumEngines;


    function getEngine(this : Propulsion_Units; index : Natural) return Engines is
    begin
        return this.engine_cluster.element(index);
    end getEngine;


    procedure removeEngine(this : in out Propulsion_Units; index : Natural) is
    begin
        this.engine_cluster.delete(index);
    end removeEngine;


    overriding
    function getCost(this : Propulsion_Units) return Float is
        total_cost : Float := Components(this).getCost;

        procedure add_tank_cost(c : Tank_Vectors.Cursor) is
            tank : Tanks := Tank_Vectors.Element(c);
        begin
            total_cost := total_cost + tank.getCost;
        end add_tank_cost;

        procedure add_engine_cost(c : Engine_Vectors.Cursor) is
            engine : Engines := Engine_Vectors.Element(c);
        begin
            total_cost := total_cost + engine.getCost;
        end add_engine_cost;
    begin
        this.tankage.iterate(add_tank_cost'access);
        this.engine_cluster.iterate(add_engine_cost'access);

        return total_cost;
    end getCost;


    overriding
    function getDryMass(this : Propulsion_Units) return Float is
        total_mass : Float := Components(this).getDryMass;

        procedure add_tank_mass(c : Tank_Vectors.Cursor) is
            tank : Tanks := Tank_Vectors.Element(c);
        begin
            total_mass := total_mass + tank.getDryMass;
        end add_tank_mass;

        procedure add_engine_mass(c : Engine_Vectors.Cursor) is
            engine : Engines := Engine_Vectors.Element(c);
        begin
            total_mass := total_mass + engine.getDryMass;
        end add_engine_mass;
    begin
        this.tankage.iterate(add_tank_mass'access);
        this.engine_cluster.iterate(add_engine_mass'access);

        return total_mass;
    end getDryMass;


    overriding
    function getReliability(this : Propulsion_Units) return Rel_Ratio is
        total_reliability : Rel_Ratio := Components(this).getReliability;

        procedure add_tank_reliability(c : Tank_Vectors.Cursor) is
            tank : Tanks := Tank_Vectors.Element(c);
        begin
            total_reliability := total_reliability * tank.getReliability;
        end add_tank_reliability;

        procedure add_engine_reliability(c : Engine_Vectors.Cursor) is
            engine : Engines := Engine_Vectors.Element(c);
        begin
            total_reliability := total_reliability * engine.getReliability;
        end add_engine_reliability;
    begin
        this.tankage.iterate(add_tank_reliability'access);
        this.engine_cluster.iterate(add_engine_reliability'access);

        return total_reliability;
    end getReliability;


    function getAslIsp(this : Propulsion_Units) return Float is
        total_isp : Float := 0.0;
        total_thrust : Float := this.getMaxThrustAsl;

        procedure add_weighted_isp(c : Engine_Vectors.Cursor) is
            engine : Engines := Engine_Vectors.Element(c);
        begin
            total_isp := total_isp + engine.getAslIsp * engine.getMaxThrustAsl / total_thrust;
        end add_weighted_isp;
    begin
        this.engine_cluster.iterate(add_weighted_isp'access);

        return total_isp;
    end getAslIsp;


    function getVacIsp(this : Propulsion_Units) return Float is
        total_isp : Float := 0.0;
        total_thrust : Float := this.getMaxThrustVac;

        procedure add_weighted_isp(c : Engine_Vectors.Cursor) is
            engine : Engines := Engine_Vectors.Element(c);
        begin
            total_isp := total_isp + engine.getVacIsp * engine.getMaxThrustVac / total_thrust;
        end add_weighted_isp;
    begin
        this.engine_cluster.iterate(add_weighted_isp'access);

        return total_isp;
    end getVacIsp;


    function getFuelMass(this : Propulsion_Units) return Float is
        total_mass : Float := 0.0;

        procedure add_fuel_mass(c : Tank_Vectors.Cursor) is
            tank : Tanks := Tank_Vectors.Element(c);
        begin
            total_mass := total_mass + tank.getFuelMass;
        end add_fuel_mass;
    begin
        this.tankage.iterate(add_fuel_mass'access);

        return total_mass;
    end getFuelMass;


    function getWetMass(this : Propulsion_Units) return Float is
        dry_mass : Float := this.getDryMass;
        fuel_mass : Float := this.getFuelMass;
    begin
        return dry_mass + fuel_mass;
    end getWetMass;


    function getMaxThrustAsl(this : Propulsion_Units) return Float is
        total_thrust : Float := 0.0;

        procedure add_engine_thrust(c : Engine_Vectors.Cursor) is
            engine : Engines := Engine_Vectors.Element(c);
        begin
            total_thrust := total_thrust + engine.getMaxThrustAsl;
        end add_engine_thrust;
    begin
        this.engine_cluster.iterate(add_engine_thrust'access);

        return total_thrust;
    end getMaxThrustAsl;


    function getMinThrustAsl(this : Propulsion_Units) return Float is
        min_thrust : Float := this.getMaxThrustAsl;

        procedure check_min_thrust(c : Engine_Vectors.Cursor) is
            engine : Engines := Engine_Vectors.Element(c);
        begin
            if min_thrust > engine.getMinThrustAsl then
                min_thrust := engine.getMinThrustAsl;
            end if;
        end check_min_thrust;
    begin
        this.engine_cluster.iterate(check_min_thrust'access);

        return min_thrust;
    end getMinThrustAsl;


    function getMaxThrustVac(this : Propulsion_Units) return Float is
        total_thrust : Float := 0.0;

        procedure add_engine_thrust(c : Engine_Vectors.Cursor) is
            engine : Engines := Engine_Vectors.Element(c);
        begin
            total_thrust := total_thrust + engine.getMaxThrustVac;
        end add_engine_thrust;
    begin
        this.engine_cluster.iterate(add_engine_thrust'access);

        return total_thrust;
    end getMaxThrustVac;


    function getMinThrustVac(this : Propulsion_Units) return Float is
        min_thrust : Float := this.getMaxThrustVac;

        procedure check_min_thrust(c : Engine_Vectors.Cursor) is
            engine : Engines := Engine_Vectors.Element(c);
        begin
            if min_thrust > engine.getMinThrustVac then
                min_thrust := engine.getMinThrustVac;
            end if;
        end check_min_thrust;
    begin
        this.engine_cluster.iterate(check_min_thrust'access);

        return min_thrust;
    end getMinThrustVac;


    function getFuelType(this : Propulsion_Units) return Fuel_Types is
    begin
        return this.tankage.first_element.getFuelType;
    end getFuelType;


    function getAslDeltaV(this : Propulsion_Units; added_mass : Float := 0.0) return Float is
        package Float_Functions is new Ada.Numerics.Generic_Elementary_Functions(Float);
        use Float_Functions;

        dry_mass : Float := this.getDryMass;
        wet_mass : Float := this.getWetMass;
        isp : Float := this.getAslIsp;
    begin
        return isp * Log(wet_mass / dry_mass) * 9.80665;
    end getAslDeltaV;


    function getVacDeltaV(this : Propulsion_Units; added_mass : Float := 0.0) return Float is
        package Float_Functions is new Ada.Numerics.Generic_Elementary_Functions(Float);
        use Float_Functions;

        dry_mass : Float := this.getDryMass;
        wet_mass : Float := this.getWetMass;
        isp : Float := this.getVacIsp;
    begin
        return isp * Log(wet_mass / dry_mass) * 9.80665;
    end getVacDeltaV;


    function getMassFlowRate(this : Propulsion_Units; throttle : Engine_Throttle) return Float is
        engine_count, engine_count_tmp : Natural := Natural(this.engine_cluster.length);
        desired_thrust : Float;
        available_thrust, available_thrust_tmp : Float := this.getMaxThrustVac;
        achieved_thrust : Float := 0.0;
        required_thrust, required_thrust_tmp : Float := 0.0;
        mass_flow_rate : Float;
        engine_shutdowns_required, engine_shutdowns_achieved : Natural := 0;
        working_throttle : Engine_Throttle := throttle;
        engine_cluster_copy : Engine_Vectors.Vector := this.engine_cluster;

        function engineSortByLargestMinThrust(L, R : Engines) return Boolean is
        begin
            return L.getMinThrustVac > R.getMinThrustVac;
        end engineSortByLargestMinThrust;

        package Engine_Sorter is new Engine_Vectors.Generic_Sorting(engineSortByLargestMinThrust);

        procedure tryToThrottle(c : Engine_Vectors.Cursor) is
            engine : Engines := Engine_Vectors.Element(c);
        begin
            mass_flow_rate := mass_flow_rate + engine.getMassFlowRate(working_throttle);
            achieved_thrust := achieved_thrust + engine.getMaxThrustVac * working_throttle;
        exception
            when Minimum_Throttle_Exceeded =>
                required_thrust_tmp := required_thrust_tmp + engine.getMinThrustVac;
                achieved_thrust := achieved_thrust + engine.getMinThrustVac;
                mass_flow_rate := mass_flow_rate + engine.getMassFlowRate(engine.getMinThrustVac / engine.getMaxThrustVac);
                engine_count_tmp := engine_count_tmp - 1;
        end tryToThrottle;
    begin
        if throttle < this.getMinThrustVac / this.getMaxThrustVac then
            raise Minimum_Throttle_Exceeded;
        else
            desired_thrust := throttle * this.getMaxThrustVac;
        end if;

        Engine_Sorter.Sort(engine_cluster_copy);

        loop
            mass_flow_rate := 0.0;
            achieved_thrust := 0.0;
            engine_shutdowns_achieved := 0;

            this.engine_cluster.iterate(tryToThrottle'access);

            required_thrust := required_thrust_tmp;
            engine_count := engine_count_tmp;
            if required_thrust > desired_thrust then
                engine_shutdowns_required := engine_shutdowns_required + 1;
                engine_count := Natural(this.engine_cluster.length) - engine_shutdowns_required;
                engine_count_tmp := engine_count;
                required_thrust := 0.0;
                required_thrust_tmp := required_thrust;
                available_thrust := available_thrust - this.engine_cluster.element(engine_shutdowns_required - 1).getMaxThrustVac;
            end if;

            working_throttle := (desired_thrust - required_thrust) / available_thrust;

            exit when achieved_thrust = desired_thrust;
        end loop;

        return mass_flow_rate;
    end getMassFlowRate;


    function getBurnTime(this : Propulsion_Units; throttle : Engine_Throttle) return Float is
        mass_flow_rate : Float;
        fuel_mass : Float := getFuelMass(this);
    begin
        mass_flow_rate := getMassFlowRate(this, throttle);
        return fuel_mass / mass_flow_rate;
    end getBurnTime;
end Propulsion_Unit_Pkg;
