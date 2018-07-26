with System.Dim.Mks; use System.Dim.Mks;

package Constants_And_Units is
    type Dollars is digits 2;

    subtype Acceleration is Mks_Type
        with Dimension => ("m/sec^2",
                            Meter   => 1,
                            Second  => -2,
                            others  => 0);

    subtype Mass_Flow is Mks_Type
        with Dimension => ("kg/s",
                            Kilogram=> 1,
                            Second  => -1,
                            others  => 0);

    subtype Velocity is Mks_Type
        with Dimension => ("m/s",
                            Meter   => 1,
                            Second  => -1,
                            others  => 0);



    gravity : constant Acceleration := 9.81 * m/(s**2);

    kN : constant Force := 1000.0 * N;
    tonnes : constant Mass := 1000.0 * kg;
end Constants_And_Units;
