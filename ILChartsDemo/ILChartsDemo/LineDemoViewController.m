#import "LineDemoViewController.h"

#import "LineSeriesDelegate.h"
#import "VerticalAxisDelegate.h"
#import "HorizontalAxisDelegate.h"

#import <ILCharts/ILChartView.h>
#import <ILCharts/Axis/ILAxis.h>
#import <ILCharts/Series/ILValuesSeries.h>
#import <ILCharts/Series/ILLineSeries.h>
#import <ILCharts/Series/ILLineSeriesDelegate.h>

@interface LineDemoViewController ()

@end

@implementation LineDemoViewController
{
    ILLineSeries       *_lineSeries;
    LineSeriesDelegate *_lineSeriesDelegate;
    
    VerticalAxisDelegate   *_verticalAxisDelegate;
    HorizontalAxisDelegate *_horizontalAxisDelegate;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupChart];
}

- (void)setupChart
{
    // Left Axis
    {
        id< ILAxis > leftAxis = [ILAxis new];
        _verticalAxisDelegate = [VerticalAxisDelegate new];
        leftAxis.delegate     = _verticalAxisDelegate;
        leftAxis.orientation  = ILAxisOrientationVertical;
        leftAxis.gravity      = ILAxisGravityLeft;
        leftAxis.size         = 60.f;
        
        [_chartView addAxis: leftAxis];
    }
    // Right Axis
    {
        id< ILAxis > rightAxis = [ILAxis new];
        rightAxis.delegate     = _verticalAxisDelegate;
        rightAxis.orientation  = ILAxisOrientationVertical;
        rightAxis.gravity      = ILAxisGravityRight;
        rightAxis.size         = 60.f;
        
        [_chartView addAxis: rightAxis];
    }
    // Bottom Axis
    {
        id< ILAxis > bottomAxis = [ILAxis new];
        _horizontalAxisDelegate = [HorizontalAxisDelegate new];
        bottomAxis.delegate     = _horizontalAxisDelegate;
        bottomAxis.orientation  = ILAxisOrientationHorizontal;
        bottomAxis.gravity      = ILAxisGravityRight;
        bottomAxis.size         = 60.f;
        
        [_chartView addAxis: bottomAxis];
    }
    // Top Axis
    {
        id< ILAxis > topAxis = [ILAxis new];
        topAxis.delegate     = _horizontalAxisDelegate;
        topAxis.orientation  = ILAxisOrientationHorizontal;
        topAxis.gravity      = ILAxisGravityLeft;
        topAxis.size         = 60.f;
        
        [_chartView addAxis: topAxis];
    }

    _chartView.contentSize = CGSizeMake(2000, 580);
    
    _lineSeries   = [ILLineSeries new];
    
    _lineSeriesDelegate = [LineSeriesDelegate new];

    _lineSeries.delegate   = _lineSeriesDelegate;

    [_chartView addSeries:_lineSeries];
}

- (IBAction)reloadAction:(id)sender
{
    [_lineSeriesDelegate refreshData];
    
    [_chartView reloadData];
}

@end
