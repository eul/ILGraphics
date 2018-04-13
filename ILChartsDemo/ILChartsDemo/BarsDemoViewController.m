#import "BarsDemoViewController.h"

#import "BarSeriesDelegate.h"
#import "VerticalAxisDelegate.h"
#import "HorizontalAxisDelegate.h"

#import <ILCharts/ILChartView.h>
#import <ILCharts/Series/ILBarsSeries.h>
#import <ILCharts/Series/ILBarsSeriesDelegate.h>
#import <ILCharts/Series/ILValuesSeries.h>

#import <ILCharts/Axis/ILAxis.h>
#import <ILCharts/Details/ILLayer.h>
#import <ILCharts/Axis/Detail/ILAxisValuesLayer.h>
#import <ILCharts/Axis/Detail/ILAxisValueLayer.h>


@interface BarsDemoViewController ()
@end

@implementation BarsDemoViewController
{
    ILBarsSeries       *_barSeries;
    BarSeriesDelegate  *_barDelegate;
    
    VerticalAxisDelegate   *_verticalAxisDelegate;
    HorizontalAxisDelegate *_horizontalAxisDelegate;
    
    BOOL _barsOrientationHorizontal;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initDelegates];
    [self setupChart];
    
    [self.chartView reloadData];

    NSLog(@"asdfasdf");
}

- (void)initDelegates
{
    _barDelegate = [BarSeriesDelegate new];
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

        [self.chartView addAxis: leftAxis];
    }
    // Right Axis
    {
        id< ILAxis > rightAxis = [ILAxis new];
        rightAxis.delegate     = _verticalAxisDelegate;
        rightAxis.orientation  = ILAxisOrientationVertical;
        rightAxis.gravity      = ILAxisGravityRight;
        rightAxis.size         = 60.f;
        
        [self.chartView addAxis: rightAxis];
    }
    // Bottom Axis
    {
        id< ILAxis > bottomAxis = [ILAxis new];
        _horizontalAxisDelegate = [HorizontalAxisDelegate new];
        bottomAxis.delegate     = _horizontalAxisDelegate;
        bottomAxis.orientation  = ILAxisOrientationHorizontal;
        bottomAxis.gravity      = ILAxisGravityRight;
        bottomAxis.size         = 60.f;
        
        [self.chartView addAxis: bottomAxis];
    }

    // Top Axis
    {
        id< ILAxis > topAxis = [ILAxis new];
        topAxis.delegate     = _horizontalAxisDelegate;
        topAxis.orientation  = ILAxisOrientationHorizontal;
        topAxis.gravity      = ILAxisGravityLeft;
        topAxis.size         = 60.f;

        [self.chartView addAxis: topAxis];
    }
    
    // Bar Series
    {
        _barSeries = [ILBarsSeries new];

        _barSeries.delegate   = _barDelegate;
        _barSeries.horizontal = _barsOrientationHorizontal;
        
        [self.chartView addSeries: _barSeries];
    }
    
    self.chartView.scrollFromTop = YES;

   [self setupChartContentSize];

    ILValuesSeries *valuesSeries = [ILValuesSeries new];
    valuesSeries.dataSource = _barSeries;
    [self.chartView addSeries: valuesSeries];
}

- (void)setupChartContentSize
{
    CGFloat chartWidth  = _barsOrientationHorizontal ? 580 : 7000;
    CGFloat chartHeight = _barsOrientationHorizontal ? 7000: 580;

    self.chartView.contentSize = CGSizeMake( chartWidth, chartHeight);
}

#pragma mark- Actions

- (IBAction)onFlipBarsOrientation:(id)sender
{
    _barsOrientationHorizontal = !_barsOrientationHorizontal;

    _barSeries.horizontal = _barsOrientationHorizontal;

    [self setupChartContentSize];

    [self.chartView reloadData];
}

- (IBAction)onReloadChart:(id)sender
{
    [_barDelegate.valuesDictonary removeAllObjects];

    [self.chartView reloadData];
}

@end
