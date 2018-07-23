package Component_Pkg is
    type Components is tagged private;
    type Components_Acc is access Components;

    subtype Rel_Ratio is Float range 0.0 .. 1.0;

    -- Component Methods
    function getCost(this : Components) return Float;
    procedure setCost(this : in out Components; cost : Float);
    function getDryMass(this : Components) return Float;
    procedure setDryMass(this : in out Components; mass : Float);
    function getReliability(this : Components) return Rel_Ratio;
    procedure setReliability(this : in out Components; reliability : Rel_Ratio);

    private
        type Components is tagged
            record
                cost : Float;
                mass : Float;
                reliability : Rel_Ratio;
            end record;
end Component_Pkg;