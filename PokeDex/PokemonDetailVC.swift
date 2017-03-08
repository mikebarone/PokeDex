//
//  PokemonDetailVC.swift
//  PokeDex
//
//  Created by Mike Barone on 2017-03-07.
//  Copyright © 2017 Mike Barone. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!
    @IBOutlet weak var nameLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name
    }

}
