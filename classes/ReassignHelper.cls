public without sharing class ReassignHelper {

    @AuraEnabled
    public static FormParam GetFormParam(FormParam sourceParam){
        FormParam retParam;
        integer intStep = 0;
        if (sourceParam!=null) if (sourceParam.step!=null) if (sourceParam.step>0)
            intStep = sourceParam.step;
        if (intStep==0) retParam = GetFirstFormParam();
        else if (intStep==1) retParam = GetSecondFormParam(sourceParam);
        else if (intStep==2) retParam = GetThirdFormParam(sourceParam);
        else if (intStep==3) retParam = GetFourthFormParam(sourceParam);
        else if (intStep==4){

        }
        else retParam = sourceParam;
        return retParam;
    }

    private static FormParam GetFourthFormParam(FormParam ThirdFormParam){
        FormParam retParam = new FormParam();
        retParam.sourceParam = ThirdFormParam;
        retParam.step = 4;
        retParam.objectName = ThirdFormParam.objectName;
        retParam.reassignActivitiesOnly = ThirdFormParam.reassignActivitiesOnly;
        retParam.reassignToId = ThirdFormParam.reassignToId;
        retParam.campaignId = ThirdFormParam.campaignId;
        retParam.searchName = ThirdFormParam.searchName;
        retParam.paramFields = new list<ParamField>();
        try{
        list<string> lstError = new list<string>();
        if (!ThirdFormParam.paramFields.isEmpty()) for (ParamField pf : ThirdFormParam.paramFields) if (string.isNotBlank(pf.fieldValue)){
            if (pf.fieldName.equalsIgnoreCase('CurrentOwnerId')) 
                retParam.currentOwnerId = pf.fieldValue;
            else if (pf.fieldName.equalsIgnoreCase('CommunityId')) 
                retParam.communityId = pf.fieldValue;
        }
        string Reassign_Records = ThirdFormParam.objectName;
        if ((('Account').equalsIgnoreCase(Reassign_Records))||(('Opportunity').equalsIgnoreCase(Reassign_Records))){
            list<string> lstCondition = new list<string>();
            if (!ThirdFormParam.paramFields.isEmpty()) for (ParamField pf : ThirdFormParam.paramFields) if (string.isNotBlank(pf.fieldValue))
            if (!pf.fieldName.equalsIgnoreCase('CurrentOwnerId')) if (!pf.fieldName.equalsIgnoreCase('CommunityId')){
                string strFldValue = '';
                if (pf.fieldType.equalsIgnoreCase('DATE')){
                    date dt = ParseDate(pf.fieldValue);
                    if (dt==null) lstError.add(pf.fieldLabel + ' field value is Invalid.');
                    else strFldValue = Datetime.newInstance(dt.year(),dt.month(),dt.day()).format('yyyy-MM-dd');
                }
                else if (pf.fieldType.equalsIgnoreCase('DATETIME')){
                    datetime dtt = ParseDateTime(pf.fieldValue);
                    if (dtt==null){
                        date dt = ParseDate(pf.fieldValue);
                        if (dt!= null ) dtt = Datetime.newInstance(dt.year(),dt.month(),dt.day());
                    }
                    if (dtt==null) lstError.add(pf.fieldLabel + ' field value is Invalid.');
                    else strFldValue = dtt.format('yyyy-MM-dd HH:mm:ss','GMT').replace(' ','T') + 'z';
                }
                else if (pf.fieldType.equalsIgnoreCase('BOOLEAN')){
                    if (ParseBoolean(pf.fieldValue)) strFldValue = 'true';
                    else strFldValue = 'false';
                }
                else if (pf.fieldType.equalsIgnoreCase('NUMBER')){
                    string temp = ParseNumber(pf.fieldValue);
                    if (string.isNotBlank(temp)) strFldValue = temp;
                    else lstError.add(pf.fieldLabel + ' field value is Invalid.');
                }
                else strFldValue = '\''+string.escapeSingleQuotes(pf.fieldValue.trim())+'\'';
                if (string.isNotBlank(strFldValue)){
                    string strOp = '=';
                    if (string.isNotBlank(pf.operator)) strOp = pf.operator;
                    string strCond = '( '+pf.fieldName+ ' ' + strOp + ' ' + strFldValue + ' )';
                    lstCondition.add(strCond);
                }
            }
            if (lstError.isEmpty()){
                string strSearch_Object = 'Referral Account';
                string strObject = 'Account';
                Map<String, Schema.SObjectField> ffmap;
                if (('Opportunity').equalsIgnoreCase(Reassign_Records)){ 
                    strSearch_Object = 'Opportunity';
                    strObject = 'Opportunity';
                    ffmap = Schema.SObjectType.Opportunity.fields.getMap();
                }
                else ffmap = Schema.SObjectType.Account.fields.getMap();
                for (Reassign_Search_Criteria__mdt rsc : [SELECT Search_Name__c, Field_Label__c, Field_Name__c, Field_Value__c, 
                Operator__c, Search_Object__c FROM Reassign_Search_Criteria__mdt WHERE Search_Object__c = :strSearch_Object AND Search_Name__c = :retParam.searchName AND (Field_Value__c != '' AND Field_Value__c != null)]){
                    if (ffmap.containsKey(rsc.Field_Name__c.tolowercase())){
                        Schema.SObjectField oField = ffmap.get(rsc.Field_Name__c.tolowercase());
                        Schema.DescribeFieldResult oFieldDesc = oField.getDescribe();
                        Schema.DisplayType oFieldType = oFieldDesc.getType();
                        string strFldValue = '';
                        if (oFieldType==Schema.DisplayType.BOOLEAN){
                            if (ParseBoolean(rsc.Field_Value__c)) strFldValue = 'true';
                            else strFldValue = 'false';
                        }
                        else if (oFieldType==Schema.DisplayType.PICKLIST){
                            strFldValue = '\''+string.escapeSingleQuotes(rsc.Field_Value__c.trim())+'\'';
                        }
                        else if (oFieldType==Schema.DisplayType.DATE){
                            date dt = ParseDate(rsc.Field_Value__c);
                            if (dt==null) lstError.add(rsc.Field_Label__c + ' field value is Invalid.');
                            else strFldValue = Datetime.newInstance(dt.year(),dt.month(),dt.day()).format('yyyy-MM-dd');
                        }
                        else if (oFieldType==Schema.DisplayType.DATETIME){
                            datetime dtt = ParseDateTime(rsc.Field_Value__c);
                            if (dtt==null){
                                date dt = ParseDate(rsc.Field_Value__c);
                                if (dt!= null ) dtt = Datetime.newInstance(dt.year(),dt.month(),dt.day());
                            }
                            if (dtt==null) lstError.add(rsc.Field_Label__c + ' field value is Invalid.');
                            else strFldValue = dtt.format('yyyy-MM-dd HH:mm:ss','GMT').replace(' ','T') + 'z';
                        }
                        else if ((oFieldType==Schema.DisplayType.CURRENCY)||(oFieldType==Schema.DisplayType.DOUBLE)||(oFieldType==Schema.DisplayType.INTEGER)||(oFieldType==Schema.DisplayType.LONG)||(oFieldType==Schema.DisplayType.PERCENT)){
                            string temp = ParseNumber(rsc.Field_Value__c);
                            if (string.isNotBlank(temp)) strFldValue = temp;
                            else lstError.add(rsc.Field_Label__c + ' field value is Invalid.');
                        }
                        else strFldValue = '\''+string.escapeSingleQuotes(rsc.Field_Label__c.trim())+'\'';

                        if (string.isNotBlank(strFldValue)){
                            string strOp = '=';
                            if (string.isNotBlank(rsc.Operator__c)) strOp = rsc.Operator__c;
                            string strCond = '( '+rsc.Field_Value__c+ ' ' + strOp + ' ' + strFldValue + ' )';
                            lstCondition.add(strCond);
                        }
                        
                    }
                }
            }
            if (lstError.isEmpty()) if (!lstCondition.isEmpty()){
                integer n = lstCondition.size();
                string strCondition = '(';
                for (integer i =0;i<n;i++){
                    string s = (i==(n-1))?')':' AND ';
                    strCondition += (lstCondition.get(i)+s);
                }
                retParam.whereCondition = strCondition;
            }
        }
        if (!lstError.isEmpty()){
            retParam.step = 99;
            retParam.message = 'ERROR: ' + String.join(lstError,' \r\n');
            return retParam;
        }
        else{
            string strMsg = 'Please confirm following parameters for running of Resassign Batch Process: \r\n';
            if (string.isNotBlank(retParam.objectName)) strMsg += '\t Object : ' + retParam.objectName + ' \r\n';
            if (retParam.reassignActivitiesOnly) strMsg += '\t Reassign Activities Only : ' + 'Yes' + ' \r\n';
            if (string.isNotBlank(retParam.reassignToId)) strMsg += '\t Reassign To User Id : ' + retParam.reassignToId + ' \r\n';
            if (string.isNotBlank(retParam.campaignId)) strMsg += '\t Campaign Id : ' + retParam.campaignId + ' \r\n';
            if (string.isNotBlank(retParam.searchName)) strMsg += '\t Search Name : ' + retParam.searchName + ' \r\n';
            if (retParam.sourceParam!=null) if (retParam.sourceParam.paramFields!=null)
            if (!retParam.sourceParam.paramFields.isEmpty())
            for (ParamField pf : retParam.sourceParam.paramFields) if (string.isNotBlank(pf.fieldValue))
            strMsg += '\t '+pf.fieldLabel+' : ' + pf.fieldValue + ' \r\n';
            retParam.message = strMsg;
        }
        }catch(Exception exc){
            retParam.message = 'Exception: ' + exc.getMessage() + ' (#' + string.valueOf(exc.getLineNumber()) + ')';
            retParam.step = 99;
        }
        return retParam;
    }

    private static date ParseDate(string strVal){
        date retDt = null;
        try{retDt=date.valueOf(strVal);}catch(Exception exc){}
        if (retDt==null) try{retDt=date.parse(strVal);}catch(Exception exc){}
        if (retDt==null) try{retDt = (Date)JSON.deserialize('"'+strVal+'"', Date.class);}catch(Exception exc){}
        return retDt;
    }
    private static dateTime ParseDateTime(string strVal){
        dateTime retDt = null;
        try{retDt=dateTime.valueOf(strVal);}catch(Exception exc){}
        if (retDt==null) try{retDt=dateTime.parse(strVal);}catch(Exception exc){}
        if (retDt==null) try{retDt = (DateTime)JSON.deserialize('"'+strVal+'"', DateTime.class);}catch(Exception exc){}
        return retDt;
    }
    private static boolean ParseBoolean(string strVal){
        boolean retDt = false;
        if (string.isNotBlank(strVal)) if (('Y'.equalsIgnoreCase(strVal))||('Yes'.equalsIgnoreCase(strVal))||('1'.equalsIgnoreCase(strVal))||('true'.equalsIgnoreCase(strVal))) retDt = true;
        return retDt;
    }
    private static string ParseNumber(string strVal){
        double d1 = null;
        integer i1 = null;
        try{d1=double.valueOf(strVal);}catch(Exception exc){}
        try{i1=integer.valueOf(strVal);}catch(Exception exc){}
        if ((d1==null)&&(i1==null)) return null;
        else return strVal;
    }

    private static FormParam GetThirdFormParam(FormParam SecondFormParam){
        FormParam retParam = new FormParam();
        retParam.sourceParam = SecondFormParam;
        retParam.step = 3;
        retParam.objectName = SecondFormParam.objectName;
        retParam.reassignActivitiesOnly = SecondFormParam.reassignActivitiesOnly;
        retParam.reassignToId = SecondFormParam.reassignToId;
        retParam.paramFields = new list<ParamField>();
        try{
        ParamField p1 = new ParamField();
        p1.fieldLabel = 'Current Owner';
        p1.fieldName = 'CurrentOwnerId';
        p1.fieldType = 'PICKLIST';
        p1.operator = '=';
        p1.picklistOptions = new list<ComboItem>();
        for (User u: [SELECT Id, Name, Username FROM User ORDER BY Name]) if (u.Id!=Id.valueOf(retParam.reassignToId))
            p1.picklistOptions.add(new ComboItem(u.Name + ' (' + u.Username + ')', Id.valueOf(string.valueOf(u.Id))));
        p1.picklistOptions.add(0,new ComboItem('<All>',''));
        p1.fieldValue = '';
        retParam.paramFields.add(p1);
        ParamField p2 = new ParamField();
        p2.fieldLabel = 'Community';
        p2.fieldName = 'CommunityId';
        p2.fieldType = 'PICKLIST';
        p2.operator = '=';
        p2.picklistOptions = new list<ComboItem>();
        for (Community__c u: [SELECT Id, Name FROM Community__c WHERE Name != 'ALL' ORDER BY Name])
            p2.picklistOptions.add(new ComboItem(u.Name, Id.valueOf(string.valueOf(u.Id))));
        p2.picklistOptions.add(0,new ComboItem('<All>',''));
        p2.fieldValue = '';
        retParam.paramFields.add(p2);
        string Reassign_Records = SecondFormParam.objectName;
        if ((('Account').equalsIgnoreCase(Reassign_Records))||(('Opportunity').equalsIgnoreCase(Reassign_Records))){
            string Search_Name = '';
            if (!SecondFormParam.paramFields.isEmpty()) for (ParamField pf : SecondFormParam.paramFields){
                if (pf.fieldName.equalsIgnoreCase('Search_Name'))
                    Search_Name = pf.fieldValue;
            }
            if (string.isNotBlank(Search_Name)){
                retParam.searchName = Search_Name;
                string strSearch_Object = 'Referral Account';
                string strObject = 'Account';
                Map<String, Schema.SObjectField> ffmap;
                if (('Opportunity').equalsIgnoreCase(Reassign_Records)){ 
                    strSearch_Object = 'Opportunity';
                    strObject = 'Opportunity';
                    ffmap = Schema.SObjectType.Opportunity.fields.getMap();
                }
                else ffmap = Schema.SObjectType.Account.fields.getMap();
                for (Reassign_Search_Criteria__mdt rsc : [SELECT Search_Name__c, Field_Label__c, Field_Name__c, Field_Value__c, Operator__c, Search_Object__c FROM Reassign_Search_Criteria__mdt WHERE Search_Object__c = :strSearch_Object AND Search_Name__c = :Search_Name AND (Field_Value__c = '' OR Field_Value__c = null)]){
                    if (ffmap.containsKey(rsc.Field_Name__c.tolowercase())){
                        Schema.SObjectField oField = ffmap.get(rsc.Field_Name__c.tolowercase());
                        Schema.DescribeFieldResult oFieldDesc = oField.getDescribe();
                        Schema.DisplayType oFieldType = oFieldDesc.getType();
                        ParamField p3 = new ParamField();
                        p3.fieldLabel = rsc.Field_Label__c;
                        p3.fieldName = oFieldDesc.getName();
                        p3.operator = rsc.Operator__c;
                        if (oFieldType==Schema.DisplayType.BOOLEAN)
                            p3.fieldType = 'BOOLEAN';
                        else if (oFieldType==Schema.DisplayType.PICKLIST)
                            p3.fieldType = 'PICKLIST';
                        else if (oFieldType==Schema.DisplayType.DATE)
                            p3.fieldType = 'DATE';
                        else if (oFieldType==Schema.DisplayType.DATETIME)
                            p3.fieldType = 'DATETIME';
                        else if ((oFieldType==Schema.DisplayType.CURRENCY)||(oFieldType==Schema.DisplayType.DOUBLE)||(oFieldType==Schema.DisplayType.INTEGER)||(oFieldType==Schema.DisplayType.LONG)||(oFieldType==Schema.DisplayType.PERCENT))
                            p3.fieldType = 'NUMBER';
                        else p3.fieldType = 'TEXT';

                        if (p3.fieldType == 'PICKLIST'){
                            List<Schema.PicklistEntry> ple = oFieldDesc.getPicklistValues();
                            p3.picklistOptions.add(new ComboItem('',''));
                            for( Schema.PicklistEntry pickListVal : ple)
                                p3.picklistOptions.add(new ComboItem(pickListVal.getLabel(),pickListVal.getValue()));
                        }
                        p3.fieldValue = '';
                        retParam.paramFields.add(p3);
                    }
                    else{
                        retParam.step = 99;
                        retParam.message = 'ERROR: ' + rsc.Field_Name__c + ' field is Not present in ' + strObject;
                        return retParam;
                    }
                }
            }
            else{
                retParam.step = 99;
                retParam.message = 'ERROR: Search Name is blank.';
                return retParam;
            }
        }
        else if ((('OpportunityByCampaign').equalsIgnoreCase(Reassign_Records))){
            if (!SecondFormParam.paramFields.isEmpty()) for (ParamField pf : SecondFormParam.paramFields){
                if (pf.fieldName.equalsIgnoreCase('Campaign')){
                    retParam.campaignId = pf.fieldValue;
                }
            }
        }
        }catch(Exception exc){
            retParam.message = 'Exception: ' + exc.getMessage() + ' (#' + string.valueOf(exc.getLineNumber()) + ')';
            retParam.step = 99;
        }
        return retParam;
    }

    private static FormParam GetSecondFormParam(FormParam firstFormParam){
        FormParam retParam = new FormParam();
        retParam.sourceParam = firstFormParam;
        retParam.step = 2;
        retParam.paramFields = new list<ParamField>();
        try{
        string Reassign_Records = '';
        if (firstFormParam!=null) if (firstFormParam.paramFields!=null) if (!firstFormParam.paramFields.isEmpty())
        for (ParamField pf : firstFormParam.paramFields){
            if (pf.fieldName.equalsIgnoreCase('Reassign_Records')){
                Reassign_Records = pf.fieldValue;
                pf.picklistOptions.clear();
            }
            else if (pf.fieldName.equalsIgnoreCase('Reassign_To')){
                pf.picklistOptions.clear();
                if (string.isNotBlank(pf.fieldValue)){
                    retParam.reassignToId = pf.fieldValue;
                }
            }
            else if (pf.fieldName.equalsIgnoreCase('Activities_Only')){
                if (string.isNotBlank(pf.fieldValue)) if ((pf.fieldValue.equalsIgnoreCase('true'))||(pf.fieldValue.equalsIgnoreCase('yes'))||(pf.fieldValue.equalsIgnoreCase('1')))
                    retParam.reassignActivitiesOnly = true;
            }
        }
        if ((('Account').equalsIgnoreCase(Reassign_Records))||(('Opportunity').equalsIgnoreCase(Reassign_Records))){
            retParam.objectName = Reassign_Records;
            set<string> setSeachName = new set<string>();
            list<string> lstSeachName = new list<string>();
            string strSearch_Object = 'Referral Account';
            if (('Opportunity').equalsIgnoreCase(Reassign_Records)) strSearch_Object = 'Opportunity';
            retParam.message = 'Please select search option for ' + strSearch_Object + '.';
            for (Reassign_Search_Criteria__mdt rsc : [SELECT Search_Name__c FROM Reassign_Search_Criteria__mdt WHERE Search_Object__c = :strSearch_Object ORDER BY Search_Name__c])
            if (string.isNotBlank(rsc.Search_Name__c)) if (!setSeachName.contains(rsc.Search_Name__c.trim().toUpperCase())){
                setSeachName.add(rsc.Search_Name__c.trim().toUpperCase());
                lstSeachName.add(rsc.Search_Name__c.trim());
            }
            if (!lstSeachName.isEmpty()){
                ParamField p3 = new ParamField();
                p3.fieldLabel = 'Search Name';
                p3.fieldName = 'Search_Name';
                p3.fieldType = 'PICKLIST';
                p3.operator = '';
                p3.picklistOptions = new list<ComboItem>();
                for (string s: lstSeachName)
                    p3.picklistOptions.add(new ComboItem(s,s));
                p3.fieldValue = lstSeachName.get(0);
                retParam.paramFields.add(p3);
            }
        }
        else if ((('OpportunityByCampaign').equalsIgnoreCase(Reassign_Records))){
            retParam.objectName = Reassign_Records;
            retParam.message = 'Please select search parameters.';
            ParamField p3 = new ParamField();
            p3.fieldLabel = 'Campaign';
            p3.fieldName = 'Campaign';
            p3.fieldType = 'PICKLIST';
            p3.operator = '';
            p3.picklistOptions = new list<ComboItem>();
            for (Campaign c: [SELECT Id, Name FROM Campaign ORDER By Name LIMIT 500])
                p3.picklistOptions.add(new ComboItem(c.Name,c.Id));
            p3.fieldValue = p3.picklistOptions.get(0).value;
            retParam.paramFields.add(p3);
        }
        }catch(Exception exc){
            retParam.message = 'Exception: ' + exc.getMessage() + ' (#' + string.valueOf(exc.getLineNumber()) + ')';
            retParam.step = 99;
        }
        return retParam;
    }
    
    private static FormParam GetFirstFormParam(){
        FormParam retParam = new FormParam();
        retParam.message = 'Please select reassignment parameters.';
        retParam.step = 1;
        retParam.paramFields = new list<ParamField>();
        try{
        ParamField p1 = new ParamField();
        p1.fieldLabel = 'Reassign Records';
        p1.fieldName = 'Reassign_Records';
        p1.fieldType = 'PICKLIST';
        p1.operator = '';
        p1.fieldValue = 'Account';
        p1.picklistOptions = new list<ComboItem>();
        p1.picklistOptions.add(new ComboItem('Referral Orgs/Contacts','Account'));
        p1.picklistOptions.add(new ComboItem('Opportunities','Opportunity'));
        p1.picklistOptions.add(new ComboItem('Opportunities by Campaign','OpportunityByCampaign'));
        retParam.paramFields.add(p1);

        ParamField p2 = new ParamField();
        p2.fieldLabel = 'Reassign Related Activities Only';
        p2.fieldName = 'Activities_Only';
        p2.fieldType = 'BOOLEAN';
        p2.operator = '';
        p2.fieldValue = 'false';
        retParam.paramFields.add(p2);

        ParamField p3 = new ParamField();
        p3.fieldLabel = 'Reassign To';
        p3.fieldName = 'Reassign_To';
        p3.fieldType = 'PICKLIST';
        p3.operator = '';
        p3.picklistOptions = new list<ComboItem>();
        Id currUserId = UserInfo.getUserId();
        string currUserName = '';
        for (User u: [SELECT Id, Name, Username FROM User Where IsActive = true OR Id = :currUserId ORDER BY Name]){
            if (u.Id==currUserId) currUserName = u.Name + ' (' + u.Username + ')';
            else p3.picklistOptions.add(new ComboItem(u.Name + ' (' + u.Username + ')',Id.valueOf(string.valueOf(u.Id))));
        }
        p3.picklistOptions.add(0,new ComboItem(currUserName,Id.valueOf(string.valueOf(currUserId))));
        p3.fieldValue = Id.valueOf(string.valueOf(currUserId));
        retParam.paramFields.add(p3);
        }catch(Exception exc){
            retParam.message = 'Exception: ' + exc.getMessage() + ' (#' + string.valueOf(exc.getLineNumber()) + ')';
            retParam.step = 99;
        }
        return retParam;
    }

    public class ParamField{
        @AuraEnabled
        public string fieldName;
        @AuraEnabled
        public string fieldLabel;
        @AuraEnabled
        public string fieldType;// (string,checkbox,combobox)
        @AuraEnabled
        public string operator;
        @AuraEnabled
        public list<ComboItem> picklistOptions;
        @AuraEnabled
        public string fieldValue;
    }

    public class ComboItem{
        @AuraEnabled
        public string label;
        @AuraEnabled
        public string value;
        public ComboItem(string plabel, string pvalue){
            this.label = plabel;
            this.value = pvalue;
        }
    }
    
    
    public class FormParam{
        @AuraEnabled
        public list<ParamField> paramFields;
        @AuraEnabled
        public string message;
        @AuraEnabled
        public integer step;
        @AuraEnabled
        public FormParam sourceParam;
        @AuraEnabled
        public string objectName;
        @AuraEnabled
        public string searchName;
        @AuraEnabled
        public boolean reassignActivitiesOnly;
        @AuraEnabled
        public string reassignToId;
        @AuraEnabled
        public string communityId;
        @AuraEnabled
        public string currentOwnerId;
        @AuraEnabled
        public string campaignId;
        @AuraEnabled
        public string whereCondition;
    }
}