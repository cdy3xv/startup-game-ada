-- Main
with System.Dim.Mks; use System.Dim.Mks;
with System.Dim.Mks_IO; use System.Dim.Mks_IO;

with Constants_And_Units; use Constants_And_Units;
with Text_IO; use Text_IO;
with Component_Pkg; use Component_Pkg;
with Fuel_System_Pkg; use Fuel_System_Pkg;
with Engine_Pkg; use Engine_Pkg;
with Tank_Pkg; use Tank_Pkg;
with Propulsion_Unit_Pkg; use Propulsion_Unit_Pkg;

with Ada.Containers.Vectors; use Ada.Containers;

procedure Main is
    Package Tank_Vectors is new Vectors(Natural, Tanks);

    Package Dollars_IO is new Text_IO.Float_IO(Dollars);
    use Dollars_IO;
    Package Float_IO is new Text_IO.Float_IO(Float);
    use Float_IO;

    SIC : Propulsion_Units;
    SIC_Tank : Tanks_Acc := new Tanks;
    F1 : Engines;
begin
    -- Design The Engine
    F1.setDryMass(9.15 * tonnes);
    F1.setReliability(0.99);
    F1.setCost(44000000.0);
    F1.setMaxThrustVac(7770.0 * kN);
    F1.setAslIsp(263.0 * s);
    F1.setVacIsp(304.0 * s);
    F1.setFuelType(Kerolox);

    -- Build The Tank
    SIC_Tank.setDryMass(11.0 * tonnes);
    SIC_Tank.setReliability(0.999);
    SIC_Tank.setCost(4000000.0);
    SIC_Tank.setBoiloffRate(0.0 * kg / s);
    SIC_Tank.setFuelCapacity(2122.8916 * tonnes);
    SIC_Tank.setFuelType(Kerolox);

    -- Assemble The Rocket!
    SIC.setDryMass(110.3584 * tonnes); -- Structure + Solid Retrograde Separation Motors + Fins
    SIC.setReliability(0.999999);
    SIC.setCost(167500000.0);
    loop
        begin
            SIC.addTank(SIC_Tank);
            SIC.addEngine(F1);
            SIC.addEngine(F1);
            SIC.addEngine(F1);
            SIC.addEngine(F1);
            SIC.addEngine(F1);
            exit;
        exception
            when Fuel_Mismatch_Exception =>
                SIC_Tank.setFuelType(F1.getFuelType);
                while SIC.getNumTanks > 0 loop
                    SIC.removeTank(0);
                end loop;
                while SIC.getNumEngines > 0 loop
                    SIC.removeEngine(0);
                end loop;
        end;
    end loop;

    Put(SIC.getWetMass / 1000.0, Aft => 3, Exp => 0, Symbol => " tonnes");
    Put_line("");
    Put(SIC.getDryMass / 1000.0, Aft => 3, Exp => 0, Symbol => " tonnes");
    Put_line("");
    Put("$");
    Put(SIC.getCost, Aft => 2, Exp => 0);
    Put_line("");
    Put(SIC.getReliability, Aft => 6, Exp => 0);
    Put_line("");
    Put(SIC.getAslIsp, Aft => 3, Exp => 0);
    Put_line("");
    Put(SIC.getMaxThrustAsl / 1000.0, Aft => 3, Exp => 0, Symbol => " kN");
    Put_line("");
    Put(SIC.getAslDeltaV(0.0 * kg), Aft => 3, Exp => 0);
    Put_line("");
    Put(SIC.getAslDeltaV(680.0 * tonnes), Aft => 3, Exp => 0);
    Put_line("");
    Put(SIC.getAslTWR(0.0 * kg), Aft => 3, Exp => 0);
    Put_line("");
    Put(SIC.getAslTWR(680.0 * tonnes), Aft => 3, Exp => 0);
    Put_line("");
    Put_line(Fuel_Types'Image(SIC.getFuelType));

    free(SIC_Tank);
end Main;
