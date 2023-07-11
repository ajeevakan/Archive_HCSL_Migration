<?xml version="1.0" encoding="UTF-8"?>
<CustomApplication xmlns="http://soap.sforce.com/2006/04/metadata">
    <actionOverrides>
        <actionName>View</actionName>
        <comment>Action override created by Lightning App Builder during activation.</comment>
        <content>Patient_Console</content>
        <formFactor>Small</formFactor>
        <skipRecordTypeSelect>false</skipRecordTypeSelect>
        <type>Flexipage</type>
        <pageOrSobjectType>Account</pageOrSobjectType>
    </actionOverrides>
    <actionOverrides>
        <actionName>View</actionName>
        <comment>Action override created by Lightning App Builder during activation.</comment>
        <content>Patient_Console</content>
        <formFactor>Large</formFactor>
        <skipRecordTypeSelect>false</skipRecordTypeSelect>
        <type>Flexipage</type>
        <pageOrSobjectType>Account</pageOrSobjectType>
    </actionOverrides>
    <brand>
        <headerColor>#0070D2</headerColor>
        <shouldOverrideOrgTheme>false</shouldOverrideOrgTheme>
    </brand>
    <formFactors>Small</formFactors>
    <formFactors>Large</formFactors>
    <isNavAutoTempTabsDisabled>false</isNavAutoTempTabsDisabled>
    <isNavPersonalizationDisabled>false</isNavPersonalizationDisabled>
    <isNavTabPersistenceDisabled>false</isNavTabPersistenceDisabled>
    <label>Health Cloud Lightning Console</label>
    <navType>Console</navType>
    <tabs>HealthCloudGA__Patients</tabs>
    <tabs>standard-Lead</tabs>
    <tabs>standard-Account</tabs>
    <tabs>HealthCloudGA__CandidatePatient__c</tabs>
    <tabs>HealthCloudGA__CarePlanTemplate__c</tabs>
    <tabs>standard-CareProgram</tabs>
    <tabs>standard-CareProgramGoal</tabs>
    <tabs>standard-CareProgramTeamMember</tabs>
    <tabs>HealthCloudGA__EhrCarePlan__c</tabs>
    <tabs>HealthCloudGA__EhrCarePlanGoal__c</tabs>
    <tabs>HealthCloudGA__EhrCarePlanParticipant__c</tabs>
    <tabs>HealthCloudGA__AccountAccountRelation__c</tabs>
    <tabs>HealthCloudGA__ReciprocalRole__c</tabs>
    <tabs>Unit__c</tabs>
    <tabs>Message__c</tabs>
    <tabs>Community__c</tabs>
    <tabs>Occupancy__c</tabs>
    <uiType>Lightning</uiType>
    <utilityBar>Health_Cloud_Lightning_Console_UtilityBar</utilityBar>
    <workspaceConfig>
        <mappings>
            <tab>Community__c</tab>
        </mappings>
        <mappings>
            <tab>HealthCloudGA__AccountAccountRelation__c</tab>
        </mappings>
        <mappings>
            <fieldName>HealthCloudGA__AccountId__c</fieldName>
            <tab>HealthCloudGA__CandidatePatient__c</tab>
        </mappings>
        <mappings>
            <fieldName>HealthCloudGA__ClonedFrom__c</fieldName>
            <tab>HealthCloudGA__CarePlanTemplate__c</tab>
        </mappings>
        <mappings>
            <tab>HealthCloudGA__EhrCarePlanGoal__c</tab>
        </mappings>
        <mappings>
            <tab>HealthCloudGA__EhrCarePlanParticipant__c</tab>
        </mappings>
        <mappings>
            <tab>HealthCloudGA__EhrCarePlan__c</tab>
        </mappings>
        <mappings>
            <tab>HealthCloudGA__Patients</tab>
        </mappings>
        <mappings>
            <tab>HealthCloudGA__ReciprocalRole__c</tab>
        </mappings>
        <mappings>
            <tab>Message__c</tab>
        </mappings>
        <mappings>
            <tab>Occupancy__c</tab>
        </mappings>
        <mappings>
            <tab>Unit__c</tab>
        </mappings>
        <mappings>
            <tab>standard-Account</tab>
        </mappings>
        <mappings>
            <fieldName>SponsorId</fieldName>
            <tab>standard-CareProgram</tab>
        </mappings>
        <mappings>
            <fieldName>CareProgramId</fieldName>
            <tab>standard-CareProgramGoal</tab>
        </mappings>
        <mappings>
            <fieldName>CareProgramId</fieldName>
            <tab>standard-CareProgramTeamMember</tab>
        </mappings>
        <mappings>
            <fieldName>HealthCloudGA__PrimaryCareProvider__c</fieldName>
            <tab>standard-Lead</tab>
        </mappings>
    </workspaceConfig>
</CustomApplication>