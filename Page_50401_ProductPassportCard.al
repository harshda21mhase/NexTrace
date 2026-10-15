page 50401 "Product Passport Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Product Passport";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Entry No"; Rec."Entry No")
                {
                }

                field(ItemNo; Rec."Item No")
                {
                }

                field(Description; Rec.Description)
                {
                }

                field("Lot No"; Rec."Lot No")
                {
                }

                field("Serial No"; Rec."Serial No")
                {
                }
            }

            group(Manufacturing)
            {
                field("Manufacturing Date"; Rec."Manufacturing Date")
                {
                }

                field("Manufacturing location"; Rec."Manufacturing location")
                {
                }
            }

            group(Origin)
            {


                field("Supplier No"; Rec."Supplier No")
                {
                }
            }

            group(Status1)
            {
                field("Purchase Order No"; Rec."Purchase Order No")
                {
                }

                field("Quality Status"; Rec."Quality Status")
                {
                }

                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action("Get Purchase Receipt Data")
            {
                ApplicationArea = All;
                Caption = 'Get Purchase Receipt Data';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ReceiptLine: Record "Purch. Rcpt. Line";
                    ReceiptHeader: Record "Purch. Rcpt. Header";
                    ItemLedgerEntry: Record "Item Ledger Entry";
                    MatchingEntries: Integer;
                begin
                    if Rec."Item No" = '' then
                        Error('Please select an Item No. first.');

                    ReceiptLine.SetRange(Type, ReceiptLine.Type::Item);
                    ReceiptLine.SetRange("No.", Rec."Item No");

                    if Rec."Purchase Order No" <> '' then
                        ReceiptLine.SetRange("Order No.", Rec."Purchase Order No");

                    if not ReceiptLine.FindSet() then
                        Error(
                            'No posted purchase receipt found for Item %1 and Purchase Order %2.',
                            Rec."Item No", Rec."Purchase Order No");

                    // Find the matching posted receipt and tracking entry.
                    MatchingEntries := 0;

                    repeat
                        ItemLedgerEntry.Reset();
                        ItemLedgerEntry.SetRange("Item No.", Rec."Item No");
                        ItemLedgerEntry.SetRange(
                            "Document No.", ReceiptLine."Document No.");
                        ItemLedgerEntry.SetRange(
                            "Entry Type", ItemLedgerEntry."Entry Type"::Purchase);

                        if ItemLedgerEntry.FindSet() then
                            repeat
                                MatchingEntries += 1;
                                if MatchingEntries = 1 then begin
                                    Rec."Lot No" := ItemLedgerEntry."Lot No.";
                                    Rec."Serial No" := ItemLedgerEntry."Serial No.";

                                    if ReceiptHeader.Get(
                                        ReceiptLine."Document No.")
                                    then begin
                                        Rec."Supplier No" :=
                                            ReceiptHeader."Buy-from Vendor No.";
                                        Rec."Purchase Order No" :=
                                            ReceiptHeader."Order No.";
                                    end;
                                end;
                            until ItemLedgerEntry.Next() = 0;
                    until ReceiptLine.Next() = 0;

                    if MatchingEntries = 0 then
                        Error(
                            'No matching Item Ledger Entry was found for Item %1.',
                            Rec."Item No");

                    if MatchingEntries > 1 then
                        Error(
                            'Multiple tracking entries were found. Select the correct receipt, lot, and serial before updating the Passport.');

                    Rec.Modify(true);
                    CurrPage.Update(false);

                    Message(
                        'Product Passport updated. Lot No.: %1, Serial No.: %2',
                        Rec."Lot No", Rec."Serial No");
                end;
            }
            action(OpenItem)
            {
                Image = Open;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ItemRec: Record Item;

                begin
                    Rec.TestField("Item No");

                    ItemRec.SetRange("No.", Rec."Item No");

                    if not ItemRec.FindFirst() then
                        Error(
                            'Item %1 was not found in the Item table.',
                            Rec."Item No");

                    Page.Run(Page::"Item Card", ItemRec);
                end;

            }
            action(ViewItemLedger)
            {
                Caption = 'View Item Ledger Entry';
                ToolTip = 'Open Item Ledger Entry & see the Inventory transaction';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = View;

                trigger OnAction()
                var
                    RecItemLedEntry: Record "Item Ledger Entry";
                begin
                    Rec.TestField("Item No");
                    RecItemLedEntry.SetRange("Item No.", Rec."Item No");

                    if Rec."Lot No" <> '' then
                        RecItemLedEntry.SetRange("Lot No.", Rec."Lot No");

                    if Rec."Serial No" <> '' then
                        RecItemLedEntry.SetRange("Serial No.", Rec."Serial No");

                    page.Run(Page::"Item Ledger Entries", RecItemLedEntry);
                end;
            }
            action(ViewTracibility)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                image = ViewPage;

                trigger OnAction()
                var
                    RecViewTraciability: Record "Tracibility Entry";
                begin
                    Rec.TestField("Item No");
                    RecViewTraciability.SetRange("Source Item No.", Rec."Item No");

                    if Rec."Lot No" <> '' then
                        RecViewTraciability.SetRange(
                            "Source Lot No.", Rec."Lot No");

                    if Rec."Serial No" <> '' then
                        RecViewTraciability.SetRange(
                                 "Source Serial No", Rec."Serial No");
                    Page.Run(50406, RecViewTraciability);
                end;
            }

            action("View Product Events")
            {
                ApplicationArea = All;
                Caption = 'View Product Events';
                Image = History;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ProductEvent: Record "Product Event";
                begin
                    Rec.TestField("Item No");

                    ProductEvent.SetRange("Item No", Rec."Item No");

                    Page.Run(50404, ProductEvent);
                end;
            }


        }

    }

    var
        MyInt: Integer;
}