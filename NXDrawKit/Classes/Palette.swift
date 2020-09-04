//
//  Palette.swift
//  NXDrawKit
//
//  Created by Nicejinux on 2016. 7. 12..
//  Copyright © 2016년 Nicejinux. All rights reserved.
//

import UIKit


@objc public protocol PaletteDelegate {
    @objc optional func didChangeBrushColor(_ color:UIColor)
    
    @objc optional func colorWithTag(_ tag: NSInteger) -> UIColor?
}


open class Palette: UIView {
    @objc open weak var delegate: PaletteDelegate?
    private var brush: Brush = Brush()

    private let buttonDiameter = UIScreen.main.bounds.width / 10.0
    private let buttonPadding = UIScreen.main.bounds.width / 25.0
    private let columnCount = 4
    
    private var colorButtonList = [CircleButton]()
    private var widthButtonList = [CircleButton]()
    
    private var totalHeight: CGFloat = 0.0;
    
    private weak var colorPaletteView: UIView?
    private weak var widthPaletteView: UIView?
    
    
    // MARK: - Initializer
    public init() {
        super.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc open func currentBrush() -> Brush {
        return self.brush
    }
    

    // MARK: - Private Methods
    override open var intrinsicContentSize : CGSize {
        let size: CGSize = CGSize(width: UIScreen().bounds.size.width, height: self.totalHeight)
        return size;
    }
    
    @objc open func setup() {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        self.setupColorView()
        self.setupDefaultValues()
    }
    
    @objc open func paletteHeight() -> CGFloat {
        return self.totalHeight
    }
    
    private func setupColorView() {
        let view = UIView()
        self.addSubview(view)
        self.colorPaletteView = view
        colorPaletteView?.translatesAutoresizingMaskIntoConstraints = false
        colorPaletteView?.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        colorPaletteView?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        colorPaletteView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        colorPaletteView?.topAnchor.constraint(equalTo: topAnchor).isActive = true
        colorPaletteView?.heightAnchor.constraint(equalToConstant: 100).isActive = true

        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.axis = .horizontal
       
        colorPaletteView?.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leadingAnchor.constraint(equalTo: colorPaletteView!.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: colorPaletteView!.trailingAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: colorPaletteView!.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: colorPaletteView!.bottomAnchor).isActive = true

        for index in 1...3 {
            let color: UIColor = self.color(index)
            let button = CircleButton(diameter: self.buttonDiameter, color: color, opacity: 1.0)
            button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
            stack.addArrangedSubview(button)
            button.addTarget(self, action:#selector(Palette.onClickColorPicker(_:)), for: .touchUpInside)
            self.colorButtonList.append(button)
        }
        
    }
    
    private func colorButtonRect(index: NSInteger, diameter: CGFloat, padding: CGFloat) -> CGRect {
        var rect: CGRect = CGRect.zero
        let indexValue = index - 1
        let count = self.columnCount
        rect.origin.x = (CGFloat(indexValue % count) * diameter) + padding + (CGFloat(indexValue % count) * padding)
        rect.origin.y = (CGFloat(indexValue / count) * diameter) + padding + (CGFloat(indexValue / count) * padding)
        rect.size = CGSize(width: diameter, height: diameter)
        
        return rect
    }
    
    private func setupDefaultValues() {
        let button: CircleButton = self.colorButtonList.first!
        button.isSelected = true
        self.brush.color = button.color!
        
    }
    
    @objc private func onClickColorPicker(_ button: CircleButton) {
        self.brush.color = button.color!;
        let shouldEnable = !self.brush.color.isEqual(UIColor.clear)

        self.resetButtonSelected(self.colorButtonList, button: button)
        self.updateColorOfButtons(self.widthButtonList, color: button.color!)
        
        self.delegate?.didChangeBrushColor?(self.brush.color)
    }

    @objc private func onClickWidthPicker(_ button: CircleButton) {
        self.brush.width = button.diameter!;
        self.resetButtonSelected(self.widthButtonList, button: button)
    }
    
    private func resetButtonSelected(_ list: [CircleButton], button: CircleButton) {
        for aButton: CircleButton in list {
            aButton.isSelected = aButton.isEqual(button)
        }
    }
    
    private func updateColorOfButtons(_ list: [CircleButton], color: UIColor, enable: Bool = true) {
        for aButton: CircleButton in list {
            aButton.update(color)
            aButton.isEnabled = enable
        }
    }
    
    private func color(_ tag: NSInteger) -> UIColor {
        if let color = self.delegate?.colorWithTag?(tag)  {
            return color
        }

        return self.colorWithTag(tag)
    }
    
    private func colorWithTag(_ tag: NSInteger) -> UIColor {
        switch(tag) {
            case 1:
                return UIColor.black
            case 2:
                return UIColor.yellow
            case 3:
                return UIColor.red
            default:
                return UIColor.black
        }
    }

}
