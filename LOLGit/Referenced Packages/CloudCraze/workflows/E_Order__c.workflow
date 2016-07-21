<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Order_Complete</fullName>
        <description>Order Complete</description>
        <protected>false</protected>
        <recipients>
            <field>BuyerEmail__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ecommerce/CC_Order_Complete</template>
    </alerts>
    <alerts>
        <fullName>Order_Confirmation_Email_Template</fullName>
        <description>Order Confirmation Email Template</description>
        <protected>false</protected>
        <recipients>
            <field>BuyerEmail__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ecommerce/CC_Order_Confirm</template>
    </alerts>
    <rules>
        <fullName>Order Complete</fullName>
        <actions>
            <name>Order_Complete</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>E_Order__c.OrderStatus__c</field>
            <operation>equals</operation>
            <value>In Process</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Order Confirmation</fullName>
        <actions>
            <name>Order_Confirmation_Email_Template</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>E_Order__c.OrderStatus__c</field>
            <operation>equals</operation>
            <value>Order Submitted</value>
        </criteriaItems>
        <description>Order Confirmation when order status is et to &quot;In Process&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
