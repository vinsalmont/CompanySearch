//
//  CompanyTableViewCell.swift
//  CompaniesSearch
//
//  Created by Vinicius Salmont on 11/01/21.
//

import UIKit

class CompanyTableViewCell: UITableViewCell {

    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyDescriptionLabel: UILabel!
    @IBOutlet weak var companyImageView: UIImageView!


    func setup(viewModel: HomeModels.FetchCompanies.ViewModel.DisplayedCompany) {
        self.companyImageView.download(url: viewModel.logoURL)
        self.companyNameLabel.text = viewModel.name
        self.companyDescriptionLabel.text = viewModel.category
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.companyImageView.image = UIImage(systemName: "photo")
        self.companyNameLabel.text = ""
        self.companyDescriptionLabel.text = ""
    }

}
