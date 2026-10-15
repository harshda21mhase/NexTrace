page 50407 "Quality Inspection List page"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Quality Inspection";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Inspection No"; Rec."Inspection No")
                {

                }
                field("Item No"; Rec."Item No")
                {

                }
                field(Description; Rec.Description)
                {

                }
                field("Lot No"; Rec."Lot No")
                {

                }
                field("serial No"; Rec."serial No")
                {

                }
                field("Inspection Date"; Rec."Inspection Date")
                {

                }
                field(Inspector; Rec.Inspector)
                {

                }
                field("Quality Result"; Rec."Quality Result")
                {

                }
                field(Remark; Rec.Remark)
                {

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }
}