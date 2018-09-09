with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Text_IO; use Ada.Text_IO;


with System.Dim.Mks_IO; use System.Dim.Mks_IO;
with Text_IO; use Text_IO;

package body Propulsion_Unit_Pkg is
    procedure checkFuelCompatibility(this : Propulsion_Units; fuel_type : Fuel_Types) is
        fuel_compatible : Boolean := true;

        procedure check_tank_fuel_type(c : Tank_Vectors.Cursor) is
            tank : Tanks := Tank_Vectors.Element(c).all;
        begin
            if tank.getFuelType /= fuel_type then
                raise Fuel_Mismatch_Exception;
            end if;
        end check_tank_fuel_type;

        procedure check_engine_fuel_type(c : Engine_Vectors.Cursor) is
            engine : Engines := Engine_Vectors.Element(c);
        begin
            if engine.getFuelType /= fuel_type then
                raise Fuel_Mismatch_Exception;
            end if;
        end check_engine_fuel_type;
    begin
        this.tankage.iterate(check_tank_fuel_type'access);
        this.engine_cluster.iterate(check_engine_fuel_type'access);
    end checkFuelCompatibility;

    procedure checkCompletion(this : Propulsion_Units) is
    begin
        if this.getNumEngines = 0 then
            raise Incomplete_Propulsion_Unit;
        end if;
        if this.getNumTanks = 0 then
            raise Incomplete_Propulsion_Unit;
        end if;
    end checkCompletion;

    procedure addTank(this : in out Propulsion_Units; to_add : Tanks_Acc) is
    begin
        this.checkFuelCompatibility(to_add.getFuelType);
        this.tankage.append(to_add);
    exception
        when Fuel_Mismatch_Exception =>
            raise;
    end addTank;


    function getNumTanks(this : Propulsion_Units) return Natural is
    begin
        return Natural(this.tankage.length);
    end getNumTanks;


    function getTank(this : Propulsion_Units; index : Natural) return Tanks is
    begin
        return this.tankage.element(index).all;
    end getTank;


    procedure removeTank(this : in out Propulsion_Units; index : Natural) is
    begin
        this.tankage.delete(index);
    end removeTank;


    procedure addEngine(this : in out Propulsion_Units; to_add : Engines) is
    begin
        this.checkFuelCompatibility(to_add.getFuelType);
        this.engine_cluster.append(to_add);
    exception
        when Fuel_Mismatch_Exception =>
            raise;
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
    function getCost(this : Propulsion_Units) return Dollars is
        total_cost : Dollars := Components(this).getCost;

        procedure add_tank_cost(c : Tank_Vectors.Cursor) is
            tank : Tanks := Tank_Vectors.Element(c).all;
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
    function getDryMass(this : Propulsion_Units) return Mass is
        total_mass : Mass := Components(this).getDryMass;

        procedure add_tank_mass(c : Tank_Vectors.Cursor) is
            tank : Tanks := Tank_Vectors.Element(c).all;
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
            tank : Tanks := Tank_Vectors.Element(c).all;
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


    function getAslIsp(this : Propulsion_Units; throttle : Engine_Throttle := 1.0) return Time is
        desired_thrust : Force := throttle * this.getMaxThrustAsl;
        achieved_thrust : Force := 0.0 * kN;
        total_isp : Time := 0.0 * s;

        procedure tryToThrottle(c : Engine_Vectors.Cursor) is
            engine : Engines := Engine_Vectors.Element(c);
            actual_throttle : Engine_Throttle;
        begin
            begin
                actual_throttle := (desired_thrust - achieved_thrust) / engine.getMaxThrustVac;
            exception
                when Constraint_Error => actual_throttle := 1.0;
            end;

            if actual_throttle > 0.0 then
                begin
                    total_isp := total_isp + engine.getAslIsp * engine.getThrustAsl(throttle) / desired_thrust;
                    achieved_thrust := achieved_thrust + engine.getMaxThrustVac * actual_throttle;
                exception
                    when Minimum_Throttle_Exceeded =>
                        actual_throttle := engine.getMinThrustVac / engine.getMaxThrustVac;
                        total_isp := total_isp + engine.getAslIsp * engine.getThrustAsl(throttle) / desired_thrust;
                        achieved_thrust := achieved_thrust + engine.getMaxThrustVac * actual_throttle;
                end;
            end if;
        end tryToThrottle;
    begin
        this.engine_cluster.iterate(tryToThrottle'access);

        if achieved_thrust /= desired_thrust then
            raise Minimum_Throttle_Exceeded;
        end if;

        return total_isp;
    end getAslIsp;


    function getVacIsp(this : Propulsion_Units; throttle : Engine_Throttle := 1.0) return Time is
        desired_thrust : Force := throttle * this.getMaxThrustVac;
        achieved_thrust : Force := 0.0 * kN;
        total_isp : Time := 0.0 * s;

        procedure tryToThrottle(c : Engine_Vectors.Cursor) is
            engine : Engines := Engine_Vectors.Element(c);
            actual_throttle : Engine_Throttle;
        begin
            begin
                actual_throttle := (desired_thrust - achieved_thrust) / engine.getMaxThrustVac;
            exception
                when Constraint_Error => actual_throttle := 1.0;
            end;

            if actual_throttle > 0.0 then
                begin
                    total_isp := total_isp + engine.getVacIsp * engine.getThrustVac(throttle) / desired_thrust;
                    achieved_thrust := achieved_thrust + engine.getMaxThrustVac * actual_throttle;
                exception
                    when Minimum_Throttle_Exceeded =>
                        actual_throttle := engine.getMinThrustVac / engine.getMaxThrustVac;
                        total_isp := total_isp + engine.getVacIsp * engine.getThrustVac(throttle) / desired_thrust;
                        achieved_thrust := achieved_thrust + engine.getMaxThrustVac * actual_throttle;
                end;
            end if;
        end tryToThrottle;
    begin

        this.engine_cluster.iterate(tryToThrottle'access);

        if achieved_thrust /= desired_thrust then
            raise Minimum_Throttle_Exceeded;
        end if;

        return total_isp;
    end getVacIsp;


    function getFuelMass(this : Propulsion_Units; fuel_load : Tank_Load := 1.0) return Mass is
        total_mass : Mass := 0.0 * kg;

        procedure add_fuel_mass(c : Tank_Vectors.Cursor) is
            tank : Tanks := Tank_Vectors.Element(c).all;
        begin
            total_mass := total_mass + tank.getFuelMass(fuel_load);
        end add_fuel_mass;
    begin
        this.tankage.iterate(add_fuel_mass'access);

        return total_mass;
    end getFuelMass;


    function getWetMass(this : Propulsion_Units; fuel_load : Tank_Load := 1.0) return Mass is
        dry_mass : Mass := this.getDryMass;
        fuel_mass : Mass := this.getFuelMass(fuel_load);
    begin
        return dry_mass + fuel_mass;
    end getWetMass;


    function getMaxThrustAsl(this : Propulsion_Units) return Force is
        total_thrust : Force := 0.0 * kN;

        procedure add_engine_thrust(c : Engine_Vectors.Cursor) is
            engine : Engines := Engine_Vectors.Element(c);
        begin
            total_thrust := total_thrust + engine.getMaxThrustAsl;
        end add_engine_thrust;
    begin
        this.engine_cluster.iterate(add_engine_thrust'access);

        return total_thrust;
    end getMaxThrustAsl;


    function getMinThrustAsl(this : Propulsion_Units) return Force is
        min_thrust : Force := this.getMaxThrustAsl;

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


    function getThrustAsl(this : Propulsion_Units; throttle : Engine_Throttle) return Force is
        desired_thrust : Force;
        achieved_thrust : Force := 0.0 * kN;

        procedure tryToThrottle(c : Engine_Vectors.Cursor) is
            engine : Engines := Engine_Vectors.Element(c);
            actual_throttle : Engine_Throttle;
        begin
            begin
                actual_throttle := (desired_thrust - achieved_thrust) / engine.getMaxThrustAsl;
            exception
                when Constraint_Error => actual_throttle := 1.0;
            end;

            if actual_throttle > 0.0 then
                begin
                    achieved_thrust := achieved_thrust + engine.getThrustAsl(actual_throttle);
                exception
                    when Minimum_Throttle_Exceeded =>
                        achieved_thrust := achieved_thrust + engine.getMinThrustAsl;
                end;
            end if;
        end tryToThrottle;
    begin
        desired_thrust := throttle * this.getMaxThrustAsl;

        this.engine_cluster.iterate(tryToThrottle'access);

        if achieved_thrust /= desired_thrust then
            raise Minimum_Throttle_Exceeded;
        end if;

        return achieved_thrust;
    end getThrustAsl;


    function getMaxThrustVac(this : Propulsion_Units) return Force is
        total_thrust : Force := 0.0 * kg*m/(s**2);

        procedure add_engine_thrust(c : Engine_Vectors.Cursor) is
            engine : Engines := Engine_Vectors.Element(c);
        begin
            total_thrust := total_thrust + engine.getMaxThrustVac;
        end add_engine_thrust;
    begin
        this.engine_cluster.iterate(add_engine_thrust'access);

        return total_thrust;
    end getMaxThrustVac;


    function getMinThrustVac(this : Propulsion_Units) return Force is
        min_thrust : Force := this.getMaxThrustVac;

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


    function getThrustVac(this : Propulsion_Units; throttle : Engine_Throttle) return Force is
        desired_thrust : Force;
        achieved_thrust : Force := 0.0 * kN;

        procedure tryToThrottle(c : Engine_Vectors.Cursor) is
            engine : Engines := Engine_Vectors.Element(c);
            actual_throttle : Engine_Throttle;
        begin
            begin
                actual_throttle := (desired_thrust - achieved_thrust) / engine.getMaxThrustVac;
            exception
                when Constraint_Error => actual_throttle := 1.0;
            end;

            if actual_throttle > 0.0 then
                begin
                    achieved_thrust := achieved_thrust + engine.getThrustVac(actual_throttle);
                exception
                    when Minimum_Throttle_Exceeded =>
                        achieved_thrust := achieved_thrust + engine.getMinThrustVac;
                end;
            end if;
        end tryToThrottle;
    begin
        desired_thrust := throttle * this.getMaxThrustVac;

        this.engine_cluster.iterate(tryToThrottle'access);

        if achieved_thrust /= desired_thrust then
            raise Minimum_Throttle_Exceeded;
        end if;

        return achieved_thrust;
    end getThrustVac;


    function getFuelType(this : Propulsion_Units) return Fuel_Types is
    begin
        return this.tankage.first_element.getFuelType;
    end getFuelType;


    function getAslDeltaV(this : Propulsion_Units; added_mass : Mass := 0.0 * kg;
                            fuel_load : Tank_Load := 1.0;
                            throttle : Engine_Throttle := 1.0) return Velocity is
        package Mks_Functions is new Ada.Numerics.Generic_Elementary_Functions(Mks_Type);
        use Mks_Functions;

        dry_mass : Mass := this.getDryMass + added_mass;
        wet_mass : Mass := this.getWetMass(fuel_load) + added_mass;
        isp : Time := this.getAslIsp(throttle);
    begin
        return isp * Log(wet_mass / dry_mass) * gravity;
    end getAslDeltaV;


    function getVacDeltaV(this : Propulsion_Units; added_mass : Mass := 0.0 * kg;
                            fuel_load : Tank_Load := 1.0;
                            throttle : Engine_Throttle := 1.0) return Velocity is
        package Mks_Functions is new Ada.Numerics.Generic_Elementary_Functions(Mks_Type);
        use Mks_Functions;

        dry_mass : Mass := this.getDryMass + added_mass;
        wet_mass : Mass := this.getWetMass(fuel_load) + added_mass;
        isp : Time := this.getVacIsp(throttle);
    begin
        return isp * Log(wet_mass / dry_mass) * gravity;
    end getVacDeltaV;


    function getAslTWR(this : Propulsion_Units;
                            added_mass : Mass := 0.0 * kg;
                            fuel_load : Tank_Load := 1.0;
                            throttle : Engine_Throttle := 1.0) return Mks_Type is
    begin
        return this.getThrustAsl(throttle) / (gravity * (this.getWetMass(fuel_load) + added_mass));
    end getAslTWR;


    function getVacTWR(this : Propulsion_Units;
                            added_mass : Mass := 0.0 * kg;
                            fuel_load : Tank_Load := 1.0;
                            throttle : Engine_Throttle := 1.0) return Mks_Type is
    begin
        return this.getThrustVac(throttle) / (gravity * (this.getWetMass(fuel_load) + added_mass));
    end getVacTWR;


    function getMassFlowRate(this : Propulsion_Units; throttle : Engine_Throttle) return Mass_Flow is
        desired_thrust : Force;
        achieved_thrust : Force := 0.0 * kN;
        mass_flow_rate : Mass_Flow;

        procedure tryToThrottle(c : Engine_Vectors.Cursor) is
            engine : Engines := Engine_Vectors.Element(c);
            actual_throttle : Engine_Throttle;
        begin
            begin
                actual_throttle := (desired_thrust - achieved_thrust) / engine.getMaxThrustVac;
            exception
                when Constraint_Error => actual_throttle := 1.0;
            end;

            if actual_throttle > 0.0 then
                begin
                    mass_flow_rate := mass_flow_rate + engine.getMassFlowRate(actual_throttle);
                    achieved_thrust := achieved_thrust + engine.getThrustVac(actual_throttle);
                exception
                    when Minimum_Throttle_Exceeded =>
                        actual_throttle := engine.getMinThrustVac / engine.getMaxThrustVac;
                        mass_flow_rate := mass_flow_rate + engine.getMassFlowRate(actual_throttle);
                        achieved_thrust := achieved_thrust + engine.getMinThrustVac;
                end;
            end if;
        end tryToThrottle;
    begin
        desired_thrust := throttle * this.getMaxThrustVac;

        this.engine_cluster.iterate(tryToThrottle'access);

        if achieved_thrust /= desired_thrust then
            raise Minimum_Throttle_Exceeded;
        end if;

        return mass_flow_rate;
    end getMassFlowRate;


    function getBurnTime(this : Propulsion_Units; throttle : Engine_Throttle) return Time is
        mass_flow_rate : Mass_Flow;
        fuel_mass : Mass := this.getFuelMass;
    begin
        mass_flow_rate := this.getMassFlowRate(throttle);
        return fuel_mass / mass_flow_rate;
    end getBurnTime;
end Propulsion_Unit_Pkg;
