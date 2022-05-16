//https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/administration/administration-custom-cds-integration
codeunit 70100 "Dataverse Events"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CRM Setup Defaults", 'OnGetCDSTableNo', '', false, false)]
    local procedure HandleOnGetCDSTableNo(BCTableNo: Integer; var CDSTableNo: Integer; var handled: Boolean)
    begin
        if BCTableNo = DATABASE::Employee then begin
            CDSTableNo := DATABASE::"CDS new_employee";
            handled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Lookup CRM Tables", 'OnLookupCRMTables', '', true, true)]
    local procedure HandleOnLookupCRMTables(CRMTableID: Integer; NAVTableId: Integer; SavedCRMId: Guid; var CRMId: Guid; IntTableFilter: Text; var Handled: Boolean)
    begin
        if CRMTableID = Database::"CDS new_employee" then
            Handled := LookupCDSWorker(SavedCRMId, CRMId, IntTableFilter);
    end;

    local procedure LookupCDSWorker(SavedCRMId: Guid; var CRMId: Guid; IntTableFilter: Text): Boolean
    var
        CDSEmployee: Record "CDS new_employee";
        OriginalCDSEmployee: Record "CDS new_employee";
        CDSEmployeeList: Page "CDS Employee List";
    begin
        if not IsNullGuid(CRMId) then begin
            if CDSEmployee.Get(CRMId) then
                CDSEmployeeList.SetRecord(CDSEmployee);
            if not IsNullGuid(SavedCRMId) then
                if OriginalCDSEmployee.Get(SavedCRMId) then
                    CDSEmployeeList.SetCurrentlyCoupledCDSEmployee(OriginalCDSEmployee);
        end;

        CDSEmployee.SetView(IntTableFilter);
        CDSEmployeeList.SetTableView(CDSEmployee);
        CDSEmployeeList.LookupMode(true);
        if CDSEmployeeList.RunModal = ACTION::LookupOK then begin
            CDSEmployeeList.GetRecord(CDSEmployee);
            CRMId := CDSEmployee.new_employeeId;
            exit(true);
        end;
        exit(false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CRM Setup Defaults", 'OnAddEntityTableMapping', '', true, true)]
    local procedure HandleOnAddEntityTableMapping(var TempNameValueBuffer: Record "Name/Value Buffer" temporary);
    var
        CRMSetupDefaults: Codeunit "CRM Setup Defaults";
    begin
        CRMSetupDefaults.AddEntityTableMapping('employee', DATABASE::Employee, TempNameValueBuffer);
        CRMSetupDefaults.AddEntityTableMapping('employee', DATABASE::"CDS new_employee", TempNameValueBuffer);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CDS Integration Mgt.", 'OnHasCompanyIdField', '', false, false)]
    local procedure HandleOnHasCompanyIdField(TableId: Integer; var HasField: Boolean)
    begin
        if TableId = Database::"CDS new_employee" then
            HasField := true;
    end;

    //Because of table mapping

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CDS Setup Defaults", 'OnAfterResetConfiguration', '', true, true)]
    local procedure HandleOnAfterResetConfiguration(CDSConnectionSetup: Record "CDS Connection Setup")
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        CDSEmployee: Record "CDS new_employee";
        Employee: Record Employee;
    begin
        InsertIntegrationTableMapping(IntegrationTableMapping, 'EMPLOYEE', DATABASE::Employee, DATABASE::"CDS new_employee", CDSEmployee.FieldNo(new_employeeId), CDSEmployee.FieldNo(ModifiedOn), '', '', true);
        InsertIntegrationFieldMapping('EMPLOYEE', Employee.FieldNo("No."), CDSEmployee.FieldNo(new_No), IntegrationFieldMapping.Direction::Bidirectional, '', true, false);
        InsertIntegrationFieldMapping('EMPLOYEE', Employee.FieldNo("First Name"), CDSEmployee.FieldNo(new_FirstName), IntegrationFieldMapping.Direction::Bidirectional, '', true, false);
        InsertIntegrationFieldMapping('EMPLOYEE', Employee.FieldNo("Last Name"), CDSEmployee.FieldNo(new_LastName), IntegrationFieldMapping.Direction::Bidirectional, '', true, false);
    end;

    local procedure InsertIntegrationTableMapping(var IntegrationTableMapping: Record "Integration Table Mapping"; MappingName: Code[20]; TableNo: Integer; IntegrationTableNo: Integer; IntegrationTableUIDFieldNo: Integer; IntegrationTableModifiedFieldNo: Integer; TableConfigTemplateCode: Code[10]; IntegrationTableConfigTemplateCode: Code[10]; SynchOnlyCoupledRecords: Boolean)
    begin
        IntegrationTableMapping.CreateRecord(MappingName, TableNo, IntegrationTableNo, IntegrationTableUIDFieldNo, IntegrationTableModifiedFieldNo, TableConfigTemplateCode, IntegrationTableConfigTemplateCode, SynchOnlyCoupledRecords, IntegrationTableMapping.Direction::Bidirectional, 'CDS');
    end;

    procedure InsertIntegrationFieldMapping(IntegrationTableMappingName: Code[20]; TableFieldNo: Integer; IntegrationTableFieldNo: Integer; SynchDirection: Option; ConstValue: Text; ValidateField: Boolean; ValidateIntegrationTableField: Boolean)
    var
        IntegrationFieldMapping: Record "Integration Field Mapping";
    begin
        IntegrationFieldMapping.CreateRecord(IntegrationTableMappingName, TableFieldNo, IntegrationTableFieldNo, SynchDirection,
            ConstValue, ValidateField, ValidateIntegrationTableField);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CRM Integration Management", 'OnBeforeHandleCustomIntegrationTableMapping', '', false, false)]
    local procedure HandleCustomIntegrationTableMappingReset(var IsHandled: Boolean; IntegrationTableMappingName: Code[20])
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        CDSEmployee: Record "CDS new_employee";
        Employee: Record "Employee";
        HumanResourceSetup: Record "Human Resources Setup";
    begin
        case IntegrationTableMappingName of
            'EMPLOYEE':
                begin
                    InsertIntegrationTableMapping(IntegrationTableMapping, 'EMPLOYEE', DATABASE::Employee, DATABASE::"CDS new_employee", CDSEmployee.FieldNo(new_employeeId), CDSEmployee.FieldNo(ModifiedOn), '', '', true);
                    InsertIntegrationFieldMapping('EMPLOYEE', Employee.FieldNo("No."), CDSEmployee.FieldNo(new_No), IntegrationFieldMapping.Direction::Bidirectional, '', true, false);
                    InsertIntegrationFieldMapping('EMPLOYEE', Employee.FieldNo("First Name"), CDSEmployee.FieldNo(new_FirstName), IntegrationFieldMapping.Direction::Bidirectional, '', true, false);
                    InsertIntegrationFieldMapping('EMPLOYEE', Employee.FieldNo("Last Name"), CDSEmployee.FieldNo(new_LastName), IntegrationFieldMapping.Direction::Bidirectional, '', true, false);
                    IsHandled := true;
                end;
        end;

    end;
}