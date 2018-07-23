-- Main
with Text_IO; use Text_IO;
with Engine_Pkg; use Engine_Pkg;
with Tank_Pkg; use Tank_Pkg;
with Propulsion_Unit_Pkg; use Propulsion_Unit_Pkg;

procedure Main is
    SIC : Propulsion_Units;
    SIC_Tank : Tanks;
    F1 : Engines;
begin
    -- Design The Engine
    F1.setDryMass(8400.0);
    F1.setReliability(0.99);
    F1.setCost(755000.0);
    F1.setMaxThrustVac(7770.0);
    F1.setAslIsp(263.0);
    F1.setVacIsp(304.0);

    -- Build The Tank
    SIC_Tank.setDryMass(11000.0);
    SIC_Tank.setReliability(0.999);
    SIC_Tank.setCost(150000.0);
    SIC_Tank.setBoiloffRate(0.0);
    SIC_Tank.setFuelCapacity(2112705.0);

    -- Assemble The Rocket!
    SIC.setDryMass(114295.0); -- Thrust Structure + Solid Retrograde Motors + Fins
    SIC.setReliability(0.999999);
    SIC.setCost(900000.0);
    SIC.addTank(SIC_Tank);
    SIC.addEngine(F1);
    SIC.addEngine(F1);
    SIC.addEngine(F1);
    SIC.addEngine(F1);
    SIC.addEngine(F1);

    Put_line(Float'Image(SIC.getWetMass));
    Put_line(Float'Image(SIC.getDryMass));
    Put_line(Float'Image(SIC.getCost));
    Put_line(Float'Image(SIC.getReliability));
    Put_line(Float'Image(SIC.getAslIsp));
    Put_line(Float'Image(SIC.getAslDeltaV));
end Main;
