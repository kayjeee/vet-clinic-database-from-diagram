-- Create the clinic database
CREATE DATABASE clinic;

-- Create the patients' relation
CREATE TABLE patients (
  id SERIAL PRIMARY KEY,    -- Unique identifier for each patient (auto-incrementing serial)
  name VARCHAR(100) NOT NULL,    -- Name of the patient (maximum 100 characters, not nullable)
  date_of_birth DATE NOT NULL    -- Date of birth of the patient (not nullable)
);

-- create the invoices relation
CREATE TABLE invoices (
  id SERIAL PRIMARY KEY,    -- Unique identifier for each invoice (auto-incrementing serial)
  total_amount DECIMAL,    -- Total amount of the invoice
  generated_at TIMESTAMP,    -- Timestamp when the invoice was generated
  payed_at TIMESTAMP,    -- Timestamp when the invoice was paid
  medical_history_id INT    -- Foreign key referencing the related medical_history record
);

--Create the medical_histories relation
CREATE TABLE medical_histories (
  id SERIAL PRIMARY KEY,    -- Unique identifier for each medical history (auto-incrementing serial)
  admitted_at TIMESTAMP,    -- Timestamp when the medical history was created/admitted
  patient_id INT NOT NULL,    -- Foreign key referencing the related patient record (not nullable)
  status VARCHAR(150)    -- Status of the medical history (maximum 150 characters)
);

-- Create the invoice_items relation
CREATE TABLE invoice_items (
  id SERIAL PRIMARY KEY,    -- Unique identifier for each invoice item (auto-incrementing serial)
  unit_price DECIMAL,    -- Price per unit of the treatment
  quantity INT,    -- Quantity of treatments
  total_price DECIMAL,    -- Total price of the invoice item
  invoice_id INT,    -- Foreign key referencing the related invoice record
  treatment_id INT    -- Foreign key referencing the related treatment record
);

-- Create the treatments relation
CREATE TABLE treatments (
  id SERIAL PRIMARY KEY,    -- Unique identifier for each treatment (auto-incrementing serial)
  type VARCHAR(150) NOT NULL,    -- Type of the treatment (maximum 150 characters, not nullable)
  name VARCHAR(100) NOT NULL    -- Name of the treatment (maximum 100 characters, not nullable)
);

-- Create medical_history_treatments to relate medical_history and treatments
CREATE TABLE medical_history_treatments (
  medical_history_id INT,    -- Foreign key referencing the related medical_history record
  treatment_id INT,    -- Foreign key referencing the related treatment record
  PRIMARY KEY (medical_history_id, treatment_id),    -- Combined primary key to prevent duplicate associations
  FOREIGN KEY (medical_history_id) REFERENCES medical_histories (id),    -- Foreign key constraint for medical_histories
  FOREIGN KEY (treatment_id) REFERENCES treatments (id)    -- Foreign key constraint for treatments
);

-- create the foreign key constraint for medical_histories
ALTER TABLE medical_histories
ADD CONSTRAINT fk_patient_id    -- Foreign key constraint name
FOREIGN KEY (patient_id)    -- Reference the patient_id column
REFERENCES patients (id);    -- Referenced table and column

-- create the foreign key constraint for invoices
ALTER TABLE invoices
ADD CONSTRAINT fk_invoice_id    -- Foreign key constraint name
FOREIGN KEY (medical_history_id)    -- Reference the medical_history_id column
REFERENCES medical_histories (id);    -- Referenced table and column

-- Create the foreign key constraints for invoice_items relation
ALTER TABLE invoice_items
ADD CONSTRAINT fk_invoice_items_invoice_id    -- Foreign key constraint name for invoice_id
FOREIGN KEY (invoice_id)    -- Reference the invoice_id column
REFERENCES invoices (id),    -- Referenced table and column
ADD CONSTRAINT fk_invoice_items_treatment_id    -- Foreign key constraint name for treatment_id
FOREIGN KEY (treatment_id)    -- Reference the treatment_id column
REFERENCES treatments (id);    -- Referenced table and column

-- Create indexes on foreign key columns to improve query performance
CREATE INDEX idx_medical_history_treatments_medical_history_id ON medical_history_treatments (medical_history_id);
CREATE INDEX idx_medical_history_treatments_treatment_id ON medical_history_treatments (treatment_id);
CREATE INDEX idx_invoice_items_invoice_id ON invoice_items (invoice_id);
CREATE INDEX idx_invoice_items_treatment_id ON invoice_items (treatment_id);
CREATE INDEX idx_invoices_medical_history_id ON invoices (medical_history_id);
CREATE INDEX idx_medical_histories_patient_id ON medical_histories (patient_id);
