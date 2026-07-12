pharmacy name
product 


{
  "type": "Select",
  "inputs": {
    "from": "@skip(outputs('Compose'), 1)",
    "select": {
      "Pharmacy": "@split(item(), ',')[0]",
      "Product": "@split(item(), ',')[1]",
      "Rx ID": "@split(item(), ',')[2]",
      "Lot Number": "@split(item(), ',')[3]",
      "Not Fulfilled": "@split(item(), ',')[4]",
      "Redirected Orders": "@split(item(), ',')[5]",
      "MultiDose Bulk": "@split(item(), ',')[6]",
      "Reason Code": "@split(item(), ',')[7]",
      "Reason": "@split(item(), ',')[8]",
      "Client Name": "@split(item(), ',')[9]",
      "Order Date": "@split(item(), ',')[10]",
      "Order Time": "@split(item(), ',')[11]",
      "Calibration Date": "@split(item(), ',')[12]",
      "Calibration Time": "@split(item(), ',')[13]",
      "Filled Date": "@split(item(), ',')[13]",
      "Filled Time": "@split(item(), ',')[14]",
      "Packed Date": "@split(item(), ',')[15]",
      "Pakced Time": "@split(item(), ',')[16]",
      "Shipped Date": "@split(item(), ',')[17]",
      "Shipped Time": "@split(item(), ',')[18]",
      "Delivered Date": "@split(item(), ',')[19]",
      "DeliveredTime": "@split(item(), ',')[20]"
    }
  },
  "runAfter": {
    "Compose": [
      "Succeeded"
    ]
  }
}

dynamic date
dynamic file name
remapping column names

### Pharmacist-in-Charge (PIC) Training Video Prompt: Priority Actions

1. **Understand your accountability.** Recognize that the PIC has ultimate responsibility for pharmacy operations, regulatory compliance, and patient safety, even when duties are delegated.

2. **Know the regulations.** Read and understand USP <825>, all pharmacy SOPs, applicable environmental monitoring and cleanroom procedures, and all state Board of Pharmacy requirements.

3. **Maintain qualified personnel.** Verify that all pharmacy staff hold current licenses or certifications, complete required training, pass competency assessments, and remain current with all requalification activities.

4. **Oversee environmental and cleanroom compliance.** Ensure required environmental monitoring is performed, review classified area certification reports promptly, and escalate any cleanroom deficiencies for correction.

5. **Ensure safe and accurate dispensing.** Verify the accuracy and appropriateness of all radiopharmaceuticals before dispensing and take immediate corrective action when deficiencies are identified.

6. **Manage complaints and quality events.** Investigate pharmacy complaints promptly, document findings, determine root causes, assess patient impact, and implement corrective or preventive actions.

7. **Meet regulatory reporting requirements.** Understand Board of Pharmacy notification rules, escalate reportable events to Pharmacy Compliance leadership, and ensure required notifications are submitted within mandated timelines.

8. **Keep the pharmacy inspection-ready every day.** Maintain compliance with all procedures, complete required documentation on time, and resolve identified issues without delay.

9. **Perform and follow up on self-inspections.** Conduct scheduled pharmacy compliance audits, document findings, track corrective actions, and verify timely resolution.

10. **Evaluate operational changes before implementation.** Review proposed workflow, process, or facility changes for regulatory impact, then update procedures, training, and documentation before implementation.

11. **Maintain required pharmacy references.** Ensure current USP standards and all required electronic and printed pharmacy references are readily available.

12. **Manage non-resident pharmacy licenses.** Coordinate with non-resident PICs to review each state's pharmacy regulations and confirm compliance with any additional requirements.

13. **Stay informed of regulatory changes.** Subscribe to Board of Pharmacy communications and routinely review newsletters, guidance documents, and regulatory updates.

14. **Participate in continuous quality improvement.** Attend PIC meetings, participate in annual SOP reviews, and contribute to ongoing policy improvements.

15. **Handle inspections professionally.** Know applicable regulations, use previous inspection findings to improve compliance, answer inspectors' questions accurately and concisely, provide only requested information, and avoid volunteering unnecessary details or documentation.


1. Pharmacy Industry – Pharmacist-in-Charge Compliance

Video Prompt:

A modern nuclear pharmacy with pharmacists and technicians working in a cleanroom environment. The Pharmacist-in-Charge reviews staff training records on a digital dashboard, verifies active licenses, examines environmental monitoring reports, and inspects a sterile ISO 5 workspace. The PIC notices a cleanroom maintenance issue, immediately escalates it to facilities, and documents corrective actions. Team members perform aseptic technique and gowning procedures while preparing radiopharmaceutical doses. Close-up shots of compliance checklists, quality documentation, and regulatory references. Bright, clean laboratory lighting, professional medical environment, cinematic corporate style, smooth camera movement, realistic people, subtle motion graphics highlighting "Training," "Compliance," "Patient Safety," and "Inspection Ready." Conclude with the PIC confidently overseeing pharmacy operations as the narration emphasizes accountability and regulatory excellence.

2. Logistics Industry – Distribution Center Operations

Video Prompt:

A large, high-tech distribution center operating at peak efficiency. A logistics operations manager monitors live warehouse dashboards showing inventory levels, shipment status, and delivery performance. Employees scan packages with handheld barcode readers while autonomous forklifts move pallets through organized aisles. A dashboard flags a delayed shipment, prompting the manager to coordinate with transportation and warehouse teams to reroute inventory and maintain customer commitments. Trucks depart loading docks on schedule as warehouse associates perform quality inspections. Modern industrial environment, bright lighting, cinematic drone shots mixed with close-up operational footage, professional business attire, realistic workflow, animated graphics displaying "Inventory Accuracy," "Real-Time Visibility," "On-Time Delivery," and "Continuous Improvement." End with satisfied customers receiving shipments on time.

3. Banking Industry – Risk Management and Regulatory Compliance

Video Prompt:

*A contemporary banking headquarters with financial professionals collaborating in a secure operations center. A compliance manager reviews transaction monitoring dashboards while analysts evaluate alerts for potential fraud and regulatory risks. Secure digital systems display customer verification, audit trails, and risk indicators. One transaction is flagged for additional review, leading the team to investigate, document findings, and escalate according to compliance procedures. Executives review governance metrics while customers use secure digital banking services with confidence. Modern financial offices, premium corporate aesthetic, cinematic lighting, smooth camera movements, realistic business professionals, subtle animated overlays featuring "Risk Monitoring," "Regulatory Compliance," "Fraud Prevention," and "Customer Trust." Finish with the bank operating securely while maintaining compliance and protecting customers.