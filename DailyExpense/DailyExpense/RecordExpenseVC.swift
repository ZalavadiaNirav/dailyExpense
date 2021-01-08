//
//  RecordExpenseVC.swift
//  DailyExpense
//
//  Created by Nirav  on 08/01/21.
//

import UIKit
import CZPicker
import TTGSnackbar

class RecordExpenseVC: UIViewController,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var amtTxt: UITextField!
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var selectCategory: UIButton!
    @IBOutlet weak var categoryCntLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addNotesTxtVw: UITextView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var picker: CZPickerView?
    var selectedCategories:String = ""
    var status:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()

    }
    
    func setupView()
    {
        addNotesTxtVw.delegate = self
        dateTxt.delegate = self
        datePicker.isHidden = true
        toolbar.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateTxt
        {
            datePicker.isHidden = false
            toolbar.isHidden = false
        }
    }
    
    // MARK: Action
    
    @IBAction func selectCategoryAction(_ sender: Any) {
        
        picker = CZPickerView(headerTitle: "Select Categories", cancelButtonTitle: "Cancel", confirmButtonTitle: "Done")
        picker!.delegate = self
        picker!.dataSource = self
        picker!.needFooterView = false
        picker!.allowMultipleSelection = true
        picker!.show(inContainer: self.view)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        
        if(titleTxt.text?.isEmpty == false && amtTxt.text?.isEmpty == false && dateTxt.text?.isEmpty == false && selectedCategories != "")
        {
        
            
            let statusMsg = DBManager.shared.insertExpense(titleStr: titleTxt.text!, amt: amtTxt.text!, dat: dateTxt.text!, categories: selectedCategories, notes: addNotesTxtVw.text ?? "")
            let snackbar = TTGSnackbar(message: statusMsg, duration: .short)
            snackbar.show()
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            let snackbar = TTGSnackbar(message: "Please Fill Mandatory Information First!", duration: .short)
            snackbar.show()
        }
    }
    

    @IBAction func DoneClick(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
       
        dateTxt.text = dateFormatter.string(from: datePicker.date)
        dateTxt.resignFirstResponder()
        datePicker.isHidden = true
        toolbar.isHidden = true
        
    }
    
    @IBAction func CancelClick(_ sender: Any) {
        datePicker.isHidden = true
        toolbar.isHidden = true
    }
    
}

extension RecordExpenseVC : CZPickerViewDelegate,CZPickerViewDataSource
{
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return  k_Category_Arr.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return k_Category_Arr[row]
    }
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
        return selectedCategories = ""
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [Any]!) {
        for row in rows {
            if let row = row as? Int {
                self.selectedCategories += k_Category_Arr[row] + ","
                
            }
        }
        if let rows = rows
        {
            categoryCntLbl.text = "\(rows.count) selected"
        }
        print(self.selectedCategories.dropLast(1))
    }
    
}



