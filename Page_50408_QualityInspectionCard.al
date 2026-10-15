page 50408 "Quality Inspection Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Quality Inspection";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Inspection No"; Rec."Inspection No")
                {

                }
                field("Item No"; Rec."Item No")
                {

                }
                field("Lot No"; Rec."Lot No")
                {

                }
                field("serial No"; Rec."serial No")
                {

                }
                field(Description; Rec.Description)
                {

                }
                field("Quality Result"; Rec."Quality Result")
                {

                }
                field("Inspection Date"; Rec."Inspection Date")
                {

                }
                field(Inspector; Rec.Inspector)
                {

                }


                field(Remark; Rec.Remark)
                {

                }
            }
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

    var
        myInt: Integer;
}